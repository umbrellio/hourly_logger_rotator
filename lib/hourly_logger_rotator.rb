# frozen_string_literal: true

require "logger"
require "hourly_logger_rotator/version"

pattern = File.join(File.dirname(__FILE__), "hourly_logger_rotator", "patch", "*.rb")
Dir[pattern].each { |file| require_relative(file) }

module HourlyLoggerRotator
  class << self
    def add_hourly_rotation_period_support!
      if hourly_mixin
        Logger::LogDevice.prepend(hourly_mixin)
      else
        warn unsupported_warning
      end
    end

    def default_rotation_period=(period)
      raise unsupported_warning if period == "hourly" && !hourly_mixin

      mixin = Module.new do
        define_method(:initialize) do |logdev, shift_age = period, *args|
          super(logdev, shift_age, *args)
        end
      end

      Logger.prepend(mixin)
    end

    private

    def hourly_mixin
      return @mixin if defined?(@mixin)

      mixin_name = "HourlyLoggerRotator::Patch::Ruby_#{RUBY_VERSION.split('.').first(2).join('_')}"
      @mixin =
        begin
          Module.const_get(mixin_name)
        rescue NameError
          nil
        end
    end

    def unsupported_warning
      "Hourly log rotation period is not supported for Ruby #{RUBY_VERSION}"
    end
  end
end

HourlyLoggerRotator.add_hourly_rotation_period_support!
