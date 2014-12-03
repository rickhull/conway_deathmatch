require 'minitest/spec'
require 'minitest/autorun'
require 'conway_deathmatch'

include ConwayDeathmatch
DEAD = BoardState::DEAD
ALIVE = BoardState::ALIVE

SHAPE = "acorn"
SHAPE_STR = "#{SHAPE} 0 0"
POINTS_COUNT = 7
SHAPE_TICK_POINTS = [
  [0, 1],
  [1, 1],
  [2, 1],
  [4, 1],
  [4, 2],
  [5, 1],
  [5, 2],
  [5, 3],
]
