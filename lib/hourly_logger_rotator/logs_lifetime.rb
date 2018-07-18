class HourlyLoggerRotator::LogsLifetime
  attr_accessor :dirname

  def initialize(dirname)
    self.dirname = dirname
  end

  def call
    return unless HourlyLoggerRotator.logs_lifetime
    Pathname.new(dirname).each_child do |entry|
      next unless entry.file?
      old_enough =  entry.mtime < (Time.now - HourlyLoggerRotator.logs_lifetime)

      if entry.basename.to_s =~ /\.log\.\d+/ && old_enough
        entry.delete
      end
    end
  end
end
