require_relative './spec_helper'

describe Shapes do
  it "must recognize #{SHAPE}" do
    Shapes.classic.fetch(SHAPE).must_be_instance_of Array
  end

  it "must confirm #{SHAPE} on the grid" do
    @grid = ConwayDeathmatch.new(20, 20)
    Shapes.add(@grid, SHAPE_STR)
    Shapes.classic.fetch(SHAPE).each { |xy_ary|
      @grid.value(*xy_ary).must_equal ALIVE
    }
  end
end
