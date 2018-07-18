
# frozen_string_literal: true

require "logger"

RSpec.describe HourlyLoggerRotator do
  next if RUBY_VERSION.start_with?("2.2.")

  context "removes old files" do
    let(:expected_files) do
      [
        "test_hourly_rotation.log",
        "test_hourly_rotation.log.123.doc",
        "test_rotation.log",
      ]
    end

    it "works" do
      HourlyLoggerRotator.gzip = true
      HourlyLoggerRotator.logs_lifetime = 1
      # Workaround for how Logger in some Ruby versions determines time changes
      # allow_any_instance_of(File).to receive_message_chain("stat.mtime") { Time.now }

      HourlyLoggerRotator.default_rotation_period = "hourly"
      Timecop.freeze

      log_dir = Pathname.new(File.expand_path("../../log", __FILE__))
      Dir.mkdir(log_dir) unless File.exist?(log_dir)
      system("rm #{log_dir}/test_hourly_rotation.log* 2> /dev/null")
      system("touch #{log_dir}/test_hourly_rotation.log.123.doc")
      system("touch #{log_dir}/test_rotation.log")

      logger = Logger.new(log_dir.join("test_hourly_rotation.log"))
      logger.debug("Line 1")
      logger.debug("Line 2")

      Timecop.travel(7200) # 2 hours
      logger.debug("Line 3")
      logger.debug("Line 4")

      logs = Dir.glob(log_dir.join("*.log*")).sort.reverse

      expect(logs.count).to eq(expected_files.size)

      expect(logs.map { |log| File.basename(log) }).to match_array(expected_files)
    end
  end
end
