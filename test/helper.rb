if ENV['CODE_COVERAGE'] and
  !%w[false no].include?(ENV['CODE_COVERAGE'].downcase)
  require 'simplecov'
  require "simplecov_json_formatter"
  SimpleCov.formatters = [
    SimpleCov::Formatter::JSONFormatter,
    SimpleCov::Formatter::SimpleFormatter,
  ]
  SimpleCov.start
end
require 'minitest/autorun'
