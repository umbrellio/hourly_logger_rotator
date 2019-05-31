# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hourly_logger_rotator/version"

Gem::Specification.new do |spec|
  spec.name    = "hourly_logger_rotator"
  spec.version = HourlyLoggerRotator::VERSION
  spec.authors = ["Dmitry Gubitskiy"]
  spec.email   = ["d.gubitskiy@gmail.com", "oss@umbrellio.biz"]

  spec.summary  = "Ruby Logger patch for hourly log rotation"
  spec.homepage = "https://github.com/umbrellio/hourly_logger_rotator"
  spec.license  = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^spec/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop-config-umbrellio"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "timecop"
end
