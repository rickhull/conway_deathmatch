if ENV['CODE_COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

# require 'conway_deathmatch'
# require 'conway_deathmatch/shapes'
require 'minitest/autorun'

# now require_relative all the tests
# require_relative './grid'
# require_relative './shapes'
# require_relative './shapes_on_grid'
