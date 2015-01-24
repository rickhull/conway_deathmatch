if ENV['CODE_COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

require 'minitest/spec'
require 'minitest/autorun'
require 'conway_deathmatch'
require 'conway_deathmatch/shapes'

ALIVE = ConwayDeathmatch::ALIVE
DEAD = ConwayDeathmatch::DEAD
Shapes = ConwayDeathmatch::Shapes
