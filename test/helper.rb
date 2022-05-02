if ENV['CODE_COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

require 'minitest/autorun'
