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

      0.upto(4) { |x|
        0.upto(4) { |y|
          if x.between?(1, 2) and y.between?(1, 2)
            @board.value(x, y).must_equal ALIVE
          else
            @board.value(x, y).must_equal DEAD
          end
        }
      }
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

  describe "aggressive deathmatch" do
    it "must allow survivors to switch sides" do
      32.times {
        @board = BoardState.new(5, 3, :aggressive)
        @board.populate(1, 1, '1') # friendly
        @board.populate(2, 1, '1') # survivor
        @board.populate(3, 1, '2') # enemy

        @board.tick
        break if @board.value(2, 1) == '2'
      }

      @board.population.fetch('1').must_equal 2
      @board.population.fetch('2').must_equal 1
      0.upto(4) { |x|
        0.upto(2) { |y|
          if x == 2 and y.between?(0, 2)
            @board.value(x, y).must_equal(y == 1 ? '2' : '1')
          else
            @board.value(x, y).must_equal DEAD
          end
        }
      }
    end
  end

  describe "defensive deathmatch" do
    it "must not allow survivors to switch sides" do
      16.times {
        @board = BoardState.new(5, 3, :defensive)
        @board.populate(1, 1, '1') # friendly
        @board.populate(2, 1, '1') # survivor
        @board.populate(3, 1, '2') # enemy
        @board.tick

        @board.population.fetch('1').must_equal 3
        0.upto(4) { |x|
          0.upto(2) { |y|
            if x == 2 and y.between?(0, 2)
              @board.value(x, y).must_equal '1'
            else
              @board.value(x, y).must_equal DEAD
            end
          }
        }
      }
    end
  end

  describe "friendly deathmatch" do
    it "must allow survivors with excess hostiles nearby" do
      @board = BoardState.new(5, 5, :friendly)
      @board.populate(1, 2, '1') # friendly
      @board.populate(2, 2, '1') # survivor
      @board.populate(3, 2, '1') # friendly
      @board.populate(2, 1, '2') # enemy
      @board.populate(2, 3, '2') # enemy
      @board.tick

      @board.population.fetch('1').must_equal 1
      # (2,2) alive despite 4 neighbors, only 2 friendly; all else DEAD
      0.upto(4) { |x|
        0.upto(4) { |y|
          @board.value(x, y).must_equal (x == 2 && y == 2 ? '1' : DEAD)
        }
      }
    end
  end
end
