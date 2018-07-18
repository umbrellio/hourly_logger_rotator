# frozen_string_literal: true

class HourlyLoggerRotator::Gzip
  attr_accessor :filename

  def initialize(filename)
    self.filename = filename
  end

  def call
    return unless HourlyLoggerRotator.gzip
    system("gzip #{filename} &")
  end
end
