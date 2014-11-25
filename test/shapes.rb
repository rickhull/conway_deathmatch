require_relative './spec_helper'

describe ConwayDeathmatch::Shapes do
  before do
    @shape = "acorn"
    @shape_str = "#{@shape} 0 0"
  end

  it "should recognize #{@shape}" do
    Shapes.known.fetch(@shape).must_be_instance_of Array
  end

  it "should confirm #{@shape} on the board" do
    @board = BoardState.new(20, 20)
    Shapes.add(@board, @shape_str)
    Shapes.known.fetch(@shape).each { |xy_ary|
      @board.value(*xy_ary).must_equal ALIVE
    }
  end
end
