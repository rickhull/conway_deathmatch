require_relative './spec_helper'

describe Shapes do
  it "must recognize acorn" do
    Shapes.classic.fetch("acorn").must_be_instance_of Array
  end

  it "must confirm acorn on the grid" do
    @grid = ConwayDeathmatch.new(20, 20)
    Shapes.add(@grid, "acorn 0 0")
    Shapes.classic.fetch("acorn").each { |xy_ary|
      @grid.value(*xy_ary).must_equal ALIVE
    }
  end
end
