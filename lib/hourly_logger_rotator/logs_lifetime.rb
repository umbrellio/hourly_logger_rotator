require "pathname"

class HourlyLoggerRotator::LogsLifetime
  attr_accessor :pathname

  def initialize(filename)
    self.pathname = Pathname.new(filename)
  end

  def call
    return unless HourlyLoggerRotator.logs_lifetime
    Dir.glob(pathname.dirname.join("#{pathname.basename}*")).map { |f| Pathname.new(f) } .each do |entry|
      next unless entry.file?
      old_enough =  entry.mtime < (Time.now - HourlyLoggerRotator.logs_lifetime)

      if entry.basename.to_s =~ /\.log\.\d+\z/ && old_enough
        entry.delete
      end
    end
  end
end
