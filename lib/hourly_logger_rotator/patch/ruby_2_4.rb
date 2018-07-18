# frozen_string_literal: true
require "logger"
require "pathname"

module HourlyLoggerRotator
  module Patch
    # rubocop:disable Naming/ClassAndModuleCamelCase
    module Ruby_2_4
      # rubocop:enable Naming/ClassAndModuleCamelCase
      SiD = Logger::Period::SiD

      def initialize(log = nil, shift_age: nil, shift_size: nil, shift_period_suffix: nil)
        @dev = @filename = @shift_age = @shift_size = @shift_period_suffix = nil
        mon_initialize
        set_dev(log)
        if @filename
          @shift_age = shift_age || 7
          @shift_size = shift_size || 1048576
          suffix = shift_age == "hourly" ? "%Y%m%d%H" : (shift_period_suffix || "%Y%m%d")
          @shift_period_suffix = suffix

          unless @shift_age.is_a?(Integer)
            base_time = @dev.respond_to?(:stat) ? @dev.stat.mtime : Time.now
            @next_rotate_time = next_rotate_time(base_time, @shift_age)
          end
        end
      end

      def shift_log_period(period_end)
        suffix = period_end.strftime(@shift_period_suffix)
        age_file = "#{@filename}.#{suffix}"
        if FileTest.exist?(age_file)
          # try to avoid filename crash caused by Timestamp change.
          idx = 0
          # .99 can be overridden; avoid too much file search with 'loop do'
          while idx < 100
            idx += 1
            age_file = "#{@filename}.#{suffix}.#{idx}"
            break unless FileTest.exist?(age_file)
          end
        end
        @dev.close rescue nil
        File.rename("#{@filename}", age_file)
        @dev = create_logfile(@filename)
        HourlyLoggerRotator::Gzip.new(age_file).call if HourlyLoggerRotator.gzip
        HourlyLoggerRotator::LogsLifetime.new(Pathname.new(@filename).dirname).call
        true
      end

      def next_rotate_time(now, shift_age)
        case shift_age
        when "hourly"
          t = Time.mktime(now.year, now.month, now.mday, now.hour) + SiD / 24
        when "daily"
          t = Time.mktime(now.year, now.month, now.mday) + SiD
        when "weekly"
          t = Time.mktime(now.year, now.month, now.mday) + SiD * (7 - now.wday)
        when "monthly"
          t = Time.mktime(now.year, now.month, 1) + SiD * 32
          return Time.mktime(t.year, t.month, 1)
        else
          return now
        end
        if t.min.nonzero? or t.sec.nonzero?
          min = t.min
          t = Time.mktime(t.year, t.month, t.mday, t.hour)
          t += (SiD / 24) if min > 30
        end
        t
      end

      def previous_period_end(now, shift_age)
        case shift_age
        when "hourly"
          t = Time.mktime(now.year, now.month, now.mday, now.hour) - 1
        when "daily"
          t = Time.mktime(now.year, now.month, now.mday) - 1
        when "weekly"
          t = Time.mktime(now.year, now.month, now.mday) - (SiD * now.wday + 1)
        when "monthly"
          t = Time.mktime(now.year, now.month, 1) - 1
        else
          return now
        end
        Time.mktime(t.year, t.month, t.mday, t.hour, 59, 59)
      end
    end
  end
end
