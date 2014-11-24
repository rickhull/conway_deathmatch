require 'minitest/spec'
require 'minitest/autorun'
require 'conway_game'

include ConwayGame

describe ConwayGame::BoardState do
  
  describe "an empty board" do
    X = 5
    Y = 5
    DEAD = BoardState::DEAD
    ALIVE = BoardState::ALIVE
    
    before do
      @bs = BoardState.new(X, Y)
    end
    
    it "should have dead population" do
      @bs.population[DEAD].must_equal X*Y
      @bs.population.keys.length.must_equal 1
    end

    it "should still be dead after a tick" do
      @bs.tick.population[DEAD].must_equal X*Y
      @bs.population.keys.length.must_equal 1
    end

    it "should accept a block" do
      @bs.populate 1,1
      @bs.populate 1,2
      @bs.populate 2,1
      @bs.populate 2,2

      @bs.population[DEAD].must_equal X * Y - 4
      @bs.population[ALIVE].must_equal 4
    end
  end
end
