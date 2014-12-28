require_relative './spec_helper'

describe ConwayDeathmatch do
  describe "an empty grid" do
    before do
      @x = 5
      @y = 5
      @grid = ConwayDeathmatch.new(@x, @y)
    end

    it "must have dead population" do
      @grid.population[DEAD].must_equal @x * @y
      @grid.population.keys.length.must_equal 1
    end

    it "must still be dead after a tick" do
      @grid.tick.population[DEAD].must_equal @x*@y
      @grid.population.keys.length.must_equal 1
    end

    it "must accept a block" do
      @grid.populate 1,1
      @grid.populate 1,2
      @grid.populate 2,1
      @grid.populate 2,2

      @grid.population[DEAD].must_equal @x * @y - 4
      @grid.population[ALIVE].must_equal 4

      0.upto(4) { |x|
        0.upto(4) { |y|
          if x.between?(1, 2) and y.between?(1, 2)
            @grid.value(x, y).must_equal ALIVE
          else
            @grid.value(x, y).must_equal DEAD
          end
        }
      }
    end
  end

  describe "adding shapes" do
    before do
      @grid = ConwayDeathmatch.new(40, 40)
      Shapes.add(@grid, SHAPE_STR)
    end

    it "must recognize \"#{SHAPE_STR}\"" do
      Shapes.classic.fetch(SHAPE).each { |xy_ary|
        @grid.value(*xy_ary).must_equal ALIVE
      }
      @grid.population.fetch(ALIVE).must_equal POINTS_COUNT
    end

    it "must tick correctly" do
      @grid.tick
      SHAPE_TICK_POINTS.each { |xy_ary|
        @grid.value(*xy_ary).must_equal ALIVE
      }
      @grid.population.fetch(ALIVE).must_equal SHAPE_TICK_POINTS.length
    end
  end

  describe "aggressive deathmatch" do
    it "must allow survivors to switch sides" do
      32.times {
        @grid = ConwayDeathmatch.new(5, 3, :aggressive)
        @grid.populate(1, 1, '1') # friendly
        @grid.populate(2, 1, '1') # survivor
        @grid.populate(3, 1, '2') # enemy

        @grid.tick
        break if @grid.value(2, 1) == '2'
      }

      @grid.population.fetch('1').must_equal 2
      @grid.population.fetch('2').must_equal 1
      0.upto(4) { |x|
        0.upto(2) { |y|
          if x == 2 and y.between?(0, 2)
            @grid.value(x, y).must_equal(y == 1 ? '2' : '1')
          else
            @grid.value(x, y).must_equal DEAD
          end
        }
      }
    end
  end

  describe "defensive deathmatch" do
    it "must not allow survivors to switch sides" do
      16.times {
        @grid = ConwayDeathmatch.new(5, 3, :defensive)
        @grid.populate(1, 1, '1') # friendly
        @grid.populate(2, 1, '1') # survivor
        @grid.populate(3, 1, '2') # enemy
        @grid.tick

        @grid.population.fetch('1').must_equal 3
        0.upto(4) { |x|
          0.upto(2) { |y|
            if x == 2 and y.between?(0, 2)
              @grid.value(x, y).must_equal '1'
            else
              @grid.value(x, y).must_equal DEAD
            end
          }
        }
      }
    end
  end

  describe "friendly deathmatch" do
    it "must allow survivors with excess hostiles nearby" do
      @grid = ConwayDeathmatch.new(5, 5, :friendly)
      @grid.populate(1, 2, '1') # friendly
      @grid.populate(2, 2, '1') # survivor
      @grid.populate(3, 2, '1') # friendly
      @grid.populate(2, 1, '2') # enemy
      @grid.populate(2, 3, '2') # enemy
      @grid.tick

      @grid.population.fetch('1').must_equal 1
      # (2,2) alive despite 4 neighbors, only 2 friendly; all else DEAD
      0.upto(4) { |x|
        0.upto(4) { |y|
          @grid.value(x, y).must_equal (x == 2 && y == 2 ? '1' : DEAD)
        }
      }
    end
  end
end
