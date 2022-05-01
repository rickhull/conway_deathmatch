require_relative './spec_helper'

describe ConwayDeathmatch do
  describe "an empty grid" do
    before do
      @x = 5
      @y = 5
      @grid = ConwayDeathmatch.new(@x, @y)
    end

    it "must have dead population" do
      expect(@grid.population[DEAD]).must_equal @x * @y
      expect(@grid.population.keys.length).must_equal 1
    end

    it "must still be dead after a tick" do
      expect(@grid.tick.population[DEAD]).must_equal @x*@y
      expect(@grid.population.keys.length).must_equal 1
    end

    it "must accept a block" do
      @grid.populate 1,1
      @grid.populate 1,2
      @grid.populate 2,1
      @grid.populate 2,2

      expect(@grid.population[DEAD]).must_equal @x * @y - 4
      expect(@grid.population[ALIVE]).must_equal 4

      0.upto(4) { |x|
        0.upto(4) { |y|
          if x.between?(1, 2) and y.between?(1, 2)
            expect(@grid.value(x, y)).must_equal ALIVE
          else
            expect(@grid.value(x, y)).must_equal DEAD
          end
        }
      }
    end
  end

  describe "adding shapes" do
    before do
      @grid = ConwayDeathmatch.new(40, 40)
      Shapes.add(@grid, "acorn 0 0")
    end

    it "must recognize \"acorn 0 0\"" do
      Shapes.classic.fetch("acorn").each { |xy_ary|
        expect(@grid.value(*xy_ary)).must_equal ALIVE
      }
      expect(@grid.population.fetch(ALIVE)).must_equal 7
    end

    it "must tick correctly" do
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
        expect(@grid.value(*xy_ary)).must_equal ALIVE
      }
      expect(@grid.population.fetch(ALIVE)).must_equal new_points.length
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

      expect(@grid.population.fetch('1')).must_equal 2
      expect(@grid.population.fetch('2')).must_equal 1
      0.upto(4) { |x|
        0.upto(2) { |y|
          if x == 2 and y.between?(0, 2)
            expect(@grid.value(x, y)).must_equal(y == 1 ? '2' : '1')
          else
            expect(@grid.value(x, y)).must_equal DEAD
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

        expect(@grid.population.fetch('1')).must_equal 3
        0.upto(4) { |x|
          0.upto(2) { |y|
            if x == 2 and y.between?(0, 2)
              expect(@grid.value(x, y)).must_equal '1'
            else
              expect(@grid.value(x, y)).must_equal DEAD
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

      expect(@grid.population.fetch('1')).must_equal 1
      # (2,2) alive despite 4 neighbors, only 2 friendly; all else DEAD
      0.upto(4) { |x|
        0.upto(4) { |y|
          expect(@grid.value(x, y)).must_equal (x == 2 && y == 2 ? '1' : DEAD)
        }
      }
    end
  end
end
