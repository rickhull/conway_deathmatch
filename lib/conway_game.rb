module ConwayGame; end         # create namespace

# data structure for the board - 2d array
# implements standard and multiplayer evaluation
# static boundaries are treated as dead
#
class ConwayGame::BoardState
  class BoundsError < RuntimeError; end

  DEAD = '.'
  ALIVE = '0'
  
  def self.new_state(x_len, y_len)
    state = []
    x_len.times { state << Array.new(y_len, DEAD) }
    state
  end

  attr_accessor :multiplayer
  
  def initialize(x_len, y_len)
    # ranges, yay! (exclude_end)
    @xr = (0...x_len)
    @yr = (0...y_len)
    @state = self.class.new_state(x_len, y_len)
    @multiplayer = false
  end
  
  # Conway's Game of Life transition rules
  def next_value(x, y)
    birthright = ALIVE
    if @multiplayer
      n, birthright = neighbor_stats(x, y)
    else
      n = count_neighbors(x, y)
    end
    if alive?(x, y)
      (n == 2 or n == 3) ? birthright : DEAD
    else
      (n == 3) ? birthright : DEAD
    end
  end

  def in_bounds?(x, y)
    @xr.include?(x) and @yr.include?(y)
  end
  
  def in_bounds!(x, y)
    raise(BoundsError, "(#{x}, #{y}) (#{@xr}, #{@yr})") unless in_bounds?(x, y)
  end
  
  # out of bounds considered dead
  def alive?(x, y)
    in_bounds?(x, y) and @state[x][y] != DEAD
  end
  
  # 8 potential neighbors
  def count_neighbors(x, y)
    count = 0
    (x-1..x+1).each { |xn|
      (y-1..y+1).each { |yn|
        next if xn == x and yn == y # don't count self
        count += 1 if alive?(xn, yn) 
      }
    }
    count
  end

  # multiplayer, population of each neighbor
  def neighbor_population(x, y)
    neighbors = Hash.new(0)
    (x-1..x+1).each { |xn|
      (y-1..y+1).each { |yn|
        next if xn == x and yn == y # don't count self
        neighbors[@state[xn][yn]] += 1 if alive?(xn, yn)
      }
    }
    neighbors
  end

  # multiplayer
  def neighbor_stats(x, y)
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
  end
  
  # generate the next state table
  def tick
    new_state = self.class.new_state(@xr.last, @yr.last)
    @xr.each { |x|
      @yr.each { |y|
        new_state[x][y] = next_value(x, y)
      }
    }
    @state = new_state
    self
  end
  
  # for line-based text output, iterate over y-values first (i.e. per row)
  def render_text
    @state.transpose.map { |row| row.join }.join("\n")
  end
  alias_method :render, :render_text
end
