# frozen_string_literal: true

RSpec.describe HourlyLoggerRotator do
  next unless RUBY_VERSION.start_with?("2.2.")

  it "raises when attempting to set default hourly rotation period" do
    error = "Hourly log rotation period is not supported for Ruby #{RUBY_VERSION}"
    expect { HourlyLoggerRotator.default_rotation_period = "hourly" }.to raise_exception(error)
  end
end
