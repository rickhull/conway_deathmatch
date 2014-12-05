require_relative './spec_helper'

describe Shapes do
  it "must recognize #{SHAPE}" do
    Shapes.classic.fetch(SHAPE).must_be_instance_of Array
  end

  it "must confirm #{SHAPE} on the board" do
    @board = BoardState.new(20, 20)
    Shapes.add(@board, SHAPE_STR)
    Shapes.classic.fetch(SHAPE).each { |xy_ary|
      @board.value(*xy_ary).must_equal ALIVE
    }
  end
end
