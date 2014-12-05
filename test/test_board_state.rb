require_relative './spec_helper'

describe BoardState do
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
      @board = BoardState.new(40, 40)
      Shapes.add(@board, SHAPE_STR)
    end

    it "must recognize \"#{SHAPE_STR}\"" do
      Shapes.classic.fetch(SHAPE).each { |xy_ary|
        @board.value(*xy_ary).must_equal ALIVE
      }
      @board.population.fetch(ALIVE).must_equal POINTS_COUNT
    end

    it "must tick correctly" do
      @board.tick
      SHAPE_TICK_POINTS.each { |xy_ary|
        @board.value(*xy_ary).must_equal ALIVE
      }
      @board.population.fetch(ALIVE).must_equal SHAPE_TICK_POINTS.length
    end
  end
end
