# frozen_string_literal: true

require "hourly_logger_rotator/patch/ruby_2_4"

module HourlyLoggerRotator
  module Patch
    # rubocop:disable Naming/ClassAndModuleCamelCase
    module Ruby_2_5
      # rubocop:enable Naming/ClassAndModuleCamelCase
      include Ruby_2_4
    end
  end
end
