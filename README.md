# HourlyLoggerRotator &middot; [![Gem Version](https://badge.fury.io/rb/hourly_logger_rotator.svg)](https://badge.fury.io/rb/hourly_logger_rotator) [![Build Status](https://travis-ci.org/umbrellio/hourly_logger_rotator.svg?branch=master)](https://travis-ci.org/umbrellio/hourly_logger_rotator) [![Coverage Status](https://coveralls.io/repos/github/umbrellio/hourly_logger_rotator/badge.svg?branch=master)](https://coveralls.io/github/umbrellio/hourly_logger_rotator?branch=master)

Logger class patch for hourly log rotation support

## Requirements

Ruby 2.3, 2.4, 2.5 or 2.6

## Installation

- `gem install hourly_logger_rotator` and `require "hourly_logger_rotation"`
- Or add it to your Gemfile and `bundle`

## Usage

Requiring the gem automatically adds an `hourly` rotation period support to Ruby's standard
Logger class. You can initialize it like this:

```
Logger.new('some_log_file', 'hourly')
```

Keep in mind that loggers created before the gem is required will not
support the hourly rotation period. Specifically, in case of a Rails app,
require this before Rails initializes; a good place to do that is in `application.rb`
right after requiring `boot`

### Setting default rotation period

`HourlyLoggerRotator.default_rotation_period=(some_period)` will make it so newly created
loggers have a rotation period of `some_period` unless you provide an explicit
period in the constructor

## License
Released under MIT License

## Authors
Created by Dmitry Gubitskiy

<a href="https://github.com/umbrellio/">
<img style="float: left;" src="https://umbrellio.github.io/Umbrellio/supported_by_umbrellio.svg"
alt="Supported by Umbrellio" width="439" height="72">
</a>
