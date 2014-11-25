require_relative './spec_helper'

describe ConwayDeathmatch::BoardState do

  describe "an empty board" do
    before do
      @x = 5
      @y = 5
      @board = BoardState.new(@x, @y)
    end
    
    it "must have dead population" do
      @board.population[DEAD].must_equal @x * @y
      @board.population.keys.length.must_equal 1
    end

    it "must still be dead after a tick" do
      @board.tick.population[DEAD].must_equal @x*@y
      @board.population.keys.length.must_equal 1
    end

    it "must accept a block" do
      @board.populate 1,1
      @board.populate 1,2
      @board.populate 2,1
      @board.populate 2,2

      @board.population[DEAD].must_equal @x * @y - 4
      @board.population[ALIVE].must_equal 4
    end
  end

  describe "adding shapes" do
    before do
      @x = 40
      @y = 40
      @shape = "acorn"
      @shape_str = "#{@shape} 0 0"
      @board = BoardState.new(@x, @y)
      Shapes.add(@board, @shape_str)
    end

    it "must recognize \"#{@shape_str}\"" do
      Shapes.known.fetch(@shape).each { |xy_ary|
        @board.value(*xy_ary).must_equal ALIVE
      }
    end
  end
end
