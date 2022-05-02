if ENV['CODE_COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

require 'conway_deathmatch'
require 'conway_deathmatch/shapes'
require 'minitest/autorun'

ALIVE = ConwayDeathmatch::ALIVE
DEAD = ConwayDeathmatch::DEAD
Shapes = ConwayDeathmatch::Shapes

describe "Shapes on the grid" do
  before do
    @grid = ConwayDeathmatch.new(20, 20)
    Shapes.add(@grid, "acorn 0 0")
  end

  it "recognizes \"acorn 0 0\"" do
    Shapes.classic.fetch("acorn").each { |xy_ary|
      expect(@grid.value(*xy_ary)).must_equal ALIVE
    }
    expect(@grid.population.fetch(ALIVE)).must_equal 7
  end

  it "ticks correctly" do
    @grid.tick
    new_points = [
      [0, 1],
      [1, 1],
      [2, 1],
      [4, 1],
      [4, 2],
      [5, 1],
      [5, 2],
      [5, 3],
    ].each { |xy_ary|
      expect(@grid.value(*xy_ary)).must_equal ALIVE
    }
    expect(@grid.population.fetch(ALIVE)).must_equal new_points.length
  end
end
