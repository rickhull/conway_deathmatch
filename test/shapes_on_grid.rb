require_relative 'helper'
require 'conway_deathmatch'
require 'conway_deathmatch/shapes'

describe "Shapes on the grid" do
  before do
    @alive = ConwayDeathmatch::ALIVE
    @grid = ConwayDeathmatch.new(20, 20)
    ConwayDeathmatch::Shapes.add(@grid, "acorn 0 0")
  end

  it "recognizes \"acorn 0 0\"" do
    ConwayDeathmatch::Shapes.classic.fetch("acorn").each { |xy_ary|
      expect(@grid.value(*xy_ary)).must_equal @alive
    }
    expect(@grid.population.fetch(@alive)).must_equal 7
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
      expect(@grid.value(*xy_ary)).must_equal @alive
    }
    expect(@grid.population.fetch(@alive)).must_equal new_points.length
  end
end
