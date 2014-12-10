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
    @deathmatch = :single # :defensive, :aggressive, :friendly
  end

  def deathmatch=(val)
    s = val.to_s.downcase.to_sym
    @deathmatch = case s
                  when :single, :aggressive, :defensive, :friendly then s
                  when :s then :single
                  when :a then :aggressive
                  when :d then :defensive
                  when :f then :friendly
                  else
                    raise "unknown: #{val.inspect}"
                  end
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

  # total (alive) neighbor count and birthright
  def neighbor_stats(x, y)
    case @deathmatch
    when :single
      count = 0
      neighbor_population(x, y).each { |sym, cnt|
        count += cnt unless sym == DEAD
      }
      [count, ALIVE]
    when :aggressive
      total = 0
      largest = 0
      birthright = nil
      neighbor_population(x, y).each { |sym, cnt|
        total += cnt
        if cnt > largest
          largest = cnt
          birthright = sym
        end
      }
      [total, birthright]
    when :defensive
      raise "not implemented"
    when :friendly
      raise "not implemented"
    else
      raise "unknown: #{@deathmatch.inspect}"
    end
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
