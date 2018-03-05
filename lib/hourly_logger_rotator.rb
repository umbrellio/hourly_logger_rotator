# frozen_string_literal: true

require "logger"
require "hourly_logger_rotator/version"

Dir[File.join(File.dirname(__FILE__), "hourly_logger_rotator", "patch", "*.rb")].each do |file|
  require_relative(file)
end

mixin_name = "HourlyLoggerRotator::Patch::Ruby_#{RUBY_VERSION.split('.').first(2).join('_')}"

mixin = begin
  Module.const_get(mixin_name)
rescue NameError
  nil
end

Logger::LogDevice.prepend(mixin) if mixin
