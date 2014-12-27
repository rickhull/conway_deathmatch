#require 'lager'
module ConwayDeathmatch; end         # create namespace

# data structure for the board - 2d array
# implements standard and deathmatch evaluation
# static boundaries are treated as dead
#
class ConwayDeathmatch::BoardState
#  extend Lager
#  log_to $stderr
  class BoundsError < RuntimeError; end

  DEAD = '.'
  ALIVE = '0'

  def self.new_state(x_len, y_len)
    state = []
    x_len.times { state << Array.new(y_len, DEAD) }
    state
  end

  # nil for traditional, otherwise :aggressive, :defensive, or :friendly
  attr_accessor :deathmatch

  def initialize(x_len, y_len, deathmatch = nil)
    @x_len = x_len
    @y_len = y_len
    @state = self.class.new_state(x_len, y_len)
    @deathmatch = deathmatch
#    @lager = self.class.lager
  end

  # Conway's Game of Life transition rules
  def next_value(x, y)
    # don't bother toroidaling, only called by #tick
    n, birthright = neighbor_stats(x, y)
    if @state[x][y] != DEAD
      (n == 2 or n == 3) ? birthright : DEAD
    else
      (n == 3) ? birthright : DEAD
    end
  end

  def value(x, y)
    x = x % @x_len
    y = y % @y_len
    @state[x][y]
  end

  # total (alive) neighbor count and birthright
  def neighbor_stats(x, y)
    x = x % @x_len
    y = y % @y_len
    npop = neighbor_population(x, y).tap { |h| h.delete(DEAD) }

    case @deathmatch
    when nil
      [npop.values.reduce(0, :+), ALIVE]

    when :aggressive, :defensive
      # dead: determine majority (always 3, no need to sample for tie)
      # alive: agg: determine majority (may tie at 2); def: cell_val
      determine_majority = (@state[x][y] == DEAD or @deathmatch == :aggressive)
      total = 0
      largest = 0
      birthrights = []
      npop.each { |sym, cnt|
        total += cnt
        return [0, DEAD] if total >= 4  # [optimization]
        if determine_majority
          if cnt > largest
            largest = cnt
            birthrights = [sym]
          elsif cnt == largest
            birthrights << sym
          end
        end
      }
      [total, determine_majority ? (birthrights.sample || DEAD) : @state[x][y]]

    when :friendly
      # [optimized] with knowledge of conway rules
      # if DEAD, need 3 friendlies to qualify for birth sampling
      # if ALIVE, npop simply has the friendly count
      cell_val = if @state[x][y] == DEAD
                   npop.reduce([]) { |memo, (sym,cnt)|
                     cnt == 3 ? memo + [sym] : memo
                   }.sample || DEAD
                 else
                   @state[x][y]
                 end
      # return [0, DEAD] if no one qualifies
      [npop[cell_val] || 0, cell_val]
    else
      raise "unknown: #{@deathmatch.inspect}"
    end
  end

  # population of every neighboring entity, including DEAD
  def neighbor_population(x, y)
    x = x % @x_len
    y = y % @y_len
    neighbors = Hash.new(0)
    (x-1).upto(x+1) { |xn|
      (y-1).upto(y+1) { |yn|
        xn = xn % @x_len
        yn = yn % @y_len
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

  # set a single point
  def populate(x, y, val = ALIVE)
    x = x % @x_len
    y = y % @y_len
    @state[x][y] = val
  end

  # set several points (2d array)
  def add_points(points, x_off = 0, y_off = 0, val = ALIVE)
    points.each { |point|
      x = (point[0] + x_off) % @x_len
      y = (point[1] + y_off) % @y_len
      @state[x][y] = val
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
