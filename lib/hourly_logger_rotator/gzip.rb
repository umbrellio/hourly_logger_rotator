class HourlyLoggerRotator::Gzip
  attr_accessor :filename

  def initialize(filename)
    self.filename = filename
  end

  def call
    return unless HourlyLoggerRotator.gzip
    puts "gzipping #{filename}"
    system("gzip #{filename}")
  end
end
