# frozen_string_literal: true

require "hourly_logger_rotator/patch/ruby_2_4"

module HourlyLoggerRotator
  module Patch
    module Ruby_2_6 # rubocop:disable Naming/ClassAndModuleCamelCase
      include Ruby_2_4
    end
  end
end
