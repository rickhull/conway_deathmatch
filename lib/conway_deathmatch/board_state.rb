module ConwayDeathmatch; end         # create namespace

# data structure for the board - 2d array
# implements standard and deathmatch evaluation
# static boundaries are treated as dead
#
class ConwayDeathmatch::BoardState
  class BoundsError < RuntimeError; end

  DEAD = '.'
  ALIVE = '0'

  def self.new_state(x_len, y_len)
    state = []
    x_len.times { state << Array.new(y_len, DEAD) }
    state
  end

  attr_accessor :deathmatch

  def initialize(x_len, y_len)
    @x_len = x_len
    @y_len = y_len
    @state = self.class.new_state(x_len, y_len)
    @deathmatch = nil # :aggressive, :defensive, :friendly
  end

  # Conway's Game of Life transition rules
  def next_value(x, y)
    n, birthright = neighbor_stats(x, y)
    if alive?(x, y)
      (n == 2 or n == 3) ? birthright : DEAD
    else
      (n == 3) ? birthright : DEAD
    end
  end

  # total (alive) neighbor count and birthright
  def neighbor_stats(x, y)
    cell_val = @state[x][y]
    np = neighbor_population(x, y)
    np.delete(DEAD)

    case @deathmatch
    when nil
      count = 0
      np.each { |sym, cnt| count += cnt }
      [count, ALIVE]

    when :aggressive, :defensive
      # dead: determine majority (always 3, no need to sample for tie)
      # alive: agg: determine majority (may tie at 2); def: cell_val
      count = 0
      largest = 0
      determine_majority = (cell_val == DEAD or @deathmatch == :aggressive)
      birthright = (determine_majority ? nil : @state[x][y])
      birthrights = []
      np.each { |sym, cnt|
        count += cnt

        if determine_majority
          birthrights << sym if cnt == largest
          if cnt > largest
            largest = cnt
            birthrights = [sym]
          end
        end
      }
      [count, birthright || birthrights.sample]

    when :friendly
      # 1. we already know the count from the next_population hash
      # 2. if the cell_val is alive, then just count friendlies
      # 3. otherwise determine majority
      return [np[cell_val], cell_val] if cell_val != DEAD

      # DEAD, determine birthright by majority
      largest = 0
      birthright = nil
      np.each { |sym, cnt|
        # determine_majority
        if cnt > largest
          largest = cnt
          birthright = sym
        end
      }
      if birthright
        [np[birthright], birthright]
      else
        [0, DEAD]
      end
    else
      raise "unknown: #{@deathmatch.inspect}"
    end
  end

  def value(x, y)
    in_bounds!(x,y)
    @state[x][y].dup
  end

  def in_bounds?(x, y)
    x.between?(0, @x_len - 1) and y.between?(0, @y_len - 1)
  end

  def in_bounds!(x, y)
    raise(BoundsError, "(#{x}, #{y})") unless in_bounds?(x, y)
  end

  # out of bounds considered dead
  def alive?(x, y)
    @state[x][y] != DEAD rescue false
  end

  # population of every neighboring entity, including DEAD
  def neighbor_population(x, y)
    neighbors = Hash.new(0)
    (x-1 > 0 ? x-1 : 0).upto(x+1 < @x_len ? x+1 : @x_len - 1) { |xn|
      (y-1 > 0 ? y-1 : 0).upto(y+1 < @y_len ? y+1 : @y_len - 1) { |yn|
        neighbors[@state[xn][yn]] += 1 unless (xn == x and yn == y)
      }
    }
    neighbors
  end

  # generate the next state table
  def tick
    new_state = self.class.new_state(@x_len, @y_len)
    @x_len.times { |x|
      @y_len.times { |y| new_state[x][y] = next_value(x, y) }
    }
    @state = new_state
    self
  end

  # set a single point, raise on OOB
  def populate(x, y, val = ALIVE)
    in_bounds!(x, y)
    @state[x][y] = val
  end

  # set several points (2d array), ignore OOB
  def add_points(points, x_off = 0, y_off = 0, val = ALIVE)
    points.each { |point|
      x = point[0] + x_off
      y = point[1] + y_off
      @state[x][y] = val if self.in_bounds?(x, y)
    }
    self
  end

  # for line-based text output, iterate over y-values first (i.e. per row)
  def render_text
    @state.transpose.map { |row| row.join }.join("\n")
  end
  alias_method :render, :render_text

  # full board scan
  def population
    population = Hash.new(0)
    @state.each { |col| col.each { |val|  population[val] += 1  } }
    population
  end
end
