require_relative './spec_helper'

describe ConwayDeathmatch do
  describe "an empty grid" do
    before do
      @x = 5
      @y = 5
      @grid = ConwayDeathmatch.new(@x, @y)
    end

    it "consists entirely of dead cells" do
      expect(@grid.population[DEAD]).must_equal @x * @y
      expect(@grid.population.keys.length).must_equal 1
    end

    it "stays dead after a tick" do
      expect(@grid.tick.population[DEAD]).must_equal @x*@y
      expect(@grid.population.keys.length).must_equal 1
    end

    it "can be populated by a 2x2 block" do
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

    it "recognizes \"acorn 0 0\"" do
      Shapes.classic.fetch("acorn").each { |xy_ary|
        expect(@grid.value(*xy_ary)).must_equal ALIVE
      }
      expect(@grid.population.fetch(ALIVE)).must_equal 7
    end

    it "ticks correctly" do
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
    it "allows survivors to switch sides" do
      32.times {
        @grid = ConwayDeathmatch.new(5, 3, :aggressive)
        @grid.populate(1, 1, :team) # friendly
        @grid.populate(2, 1, :team) # survivor
        @grid.populate(3, 1, :hostile) # enemy

        @grid.tick
        break if @grid.value(2, 1) == :hostile
      }

      expect(@grid.population.fetch(:team)).must_equal 2
      expect(@grid.population.fetch(:hostile)).must_equal 1
      0.upto(4) { |x|
        0.upto(2) { |y|
          if x == 2 and y.between?(0, 2)
            expect(@grid.value(x, y)).must_equal(y == 1 ? :hostile : :team)
          else
            expect(@grid.value(x, y)).must_equal DEAD
          end
        }
      }
    end
  end

  describe "defensive deathmatch" do
    it "won't allow survivors to switch sides" do
      16.times {
        @grid = ConwayDeathmatch.new(5, 3, :defensive)
        @grid.populate(1, 1, :team) # friendly
        @grid.populate(2, 1, :team) # survivor
        @grid.populate(3, 1, :hostile) # enemy
        @grid.tick

        expect(@grid.population.fetch(:team)).must_equal 3
        0.upto(4) { |x|
          0.upto(2) { |y|
            if x == 2 and y.between?(0, 2)
              expect(@grid.value(x, y)).must_equal :team
            else
              expect(@grid.value(x, y)).must_equal DEAD
            end
          }
        }
      }
    end
  end

  describe "friendly deathmatch" do
    it "allows survivors even with excess hostiles nearby" do
      @grid = ConwayDeathmatch.new(5, 5, :friendly)
      @grid.populate(1, 2, :team)    # friendly
      @grid.populate(2, 2, :team)    # friendly, eventual survivor
      @grid.populate(3, 2, :team)    # friendly
      @grid.populate(2, 1, :hostile) # enemy
      @grid.populate(2, 3, :hostile) # enemy
      expect(@grid.population.fetch(:team)).must_equal 3
      expect(@grid.population.fetch(:hostile)).must_equal 2

      @grid.tick

      # (2,2) alive despite 4 neighbors (2 friendly); now all else DEAD
      expect(@grid.population.fetch(:team)).must_equal 1
      0.upto(4) { |x|
        0.upto(4) { |y|
          expect(@grid.value(x, y)).
            must_equal(x == 2 && y == 2 ? :team : DEAD)
        }
      }
    end
  end
end
