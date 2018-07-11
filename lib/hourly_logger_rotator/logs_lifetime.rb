class HourlyLoggerRotator::LogsLifetime
  attr_accessor :dirname

  def initialize(dirname)
    self.dirname = dirname
  end

  def call
    return unless HourlyLoggerRotator.logs_lifetime
    Pathname.new(dirname).each_child do |entry|
      next unless entry.file?

      if entry.basename.to_s =~ /\.log\.\d+/ && entry.mtime < HourlyLoggerRotator.logs_lifetime.ago
        puts "deleting #{entry}"
        entry.delete
      end
    end
  end
end
