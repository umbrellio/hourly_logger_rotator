# frozen_string_literal: true

require "logger"

RSpec.describe HourlyLoggerRotator do
  next if RUBY_VERSION.start_with?("2.2.")

  it "rotates hourly" do
    # Workaround for how Logger in some Ruby versions determines time changes
    allow_any_instance_of(File).to receive_message_chain("stat.mtime") { Time.now }

    HourlyLoggerRotator.default_rotation_period = "hourly"
    Timecop.freeze("2000.01.01 12:30")

    log_dir = Pathname.new(File.expand_path("../log", __dir__))
    Dir.mkdir(log_dir) unless File.exist?(log_dir)
    system("rm #{log_dir}/test_hourly_rotation.log* 2> /dev/null")

    logger = Logger.new(log_dir.join("test_hourly_rotation.log"))
    logger.debug("Line 1")
    logger.debug("Line 2")

    Timecop.travel(7200) # 2 hours
    logger.debug("Line 3")
    logger.debug("Line 4")

    logs = Dir.glob(log_dir.join("test_hourly_rotation.log*")).sort.reverse
    expect(logs.count).to eq(2)
    expected = ["test_hourly_rotation.log", "test_hourly_rotation.log.2000010113"]
    expect(logs.map { |log| File.basename(log) }).to match_array(expected)

    expect(File.read(logs.first)).to match(/Line 1.*Line 2/m)
    expect(File.read(logs.last)).to match(/Line 3.*Line 4/m)
  end
end
