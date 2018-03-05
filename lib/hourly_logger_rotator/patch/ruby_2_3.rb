# frozen_string_literal: true

require "logger"

module HourlyLoggerRotator
  module Patch
    # rubocop:disable Naming/ClassAndModuleCamelCase
    module Ruby_2_3
      # rubocop:enable Naming/ClassAndModuleCamelCase
      SiD = Logger::Period::SiD

      def shift_log_period(period_end)
        format = @shift_age == "hourly" ? "%Y%m%d%H" : "%Y%m%d"
        postfix = period_end.strftime(format)
        age_file = "#{@filename}.#{postfix}"
        if FileTest.exist?(age_file)
          # try to avoid filename crash caused by Timestamp change.
          idx = 0
          # .99 can be overridden; avoid too much file search with 'loop do'
          while idx < 100
            idx += 1
            age_file = "#{@filename}.#{postfix}.#{idx}"
            break unless FileTest.exist?(age_file)
          end
        end
        @dev.close rescue nil
        File.rename(@filename.to_s, age_file)
        @dev = create_logfile(@filename)
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
