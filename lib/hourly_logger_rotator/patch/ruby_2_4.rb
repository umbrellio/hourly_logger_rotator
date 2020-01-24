# frozen_string_literal: true

module HourlyLoggerRotator
  module Patch
    module Ruby_2_4 # rubocop:disable Naming/ClassAndModuleCamelCase
      SiD = Logger::Period::SiD

      def initialize(
        log = nil,
        shift_age: nil,
        shift_size: nil,
        shift_period_suffix: nil,
        binmode: nil
      )
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
