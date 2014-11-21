module ConwayGame; end         # create namespace

# data structure for the board - 2d array
# note, (1P) indicates implementation assumes only a single player / entity
# planning for MP support in a separate (derived?) class
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
  
  def initialize(x_len, y_len)
    # ranges, yay! (exclude_end)
    @xr = (0...x_len)
    @yr = (0...y_len)
    @state = self.class.new_state(x_len, y_len)
  end
  
  def in_bounds?(x, y)
    @xr.include?(x) and @yr.include?(y)
  end
  
  def in_bounds!(x, y)
    raise(BoundsError, "(#{x}, #{y}) (#{@xr}, #{@yr})") unless in_bounds?(x, y)
  end
  
  # initial state (1P)
  def populate(x, y)
    in_bounds!(x, y)
    @state[x][y] = ALIVE
  end

  def mp_populate(x, y, val)
    in_bounds!(x, y)
    @state[x][y] = val if @state[x][y] == DEAD
  end
  
  # for line-based text output, iterate over y-values first (i.e. per line)
  def render_text
    @state.transpose.map { |row| row.join }.join("\n")
  end
  alias_method :render, :render_text
  
  # generate a new state table
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
  
  # (1P) - MP support requires neighbor counts and identities
  def next_value(x, y)
    n = count_neighbors(x, y)
    if alive?(x, y)
      (n == 2 or n == 3) ? ALIVE : DEAD
    else
      (n == 3) ? ALIVE : DEAD
    end
  end

  # assumes specific boundary behavior
  def alive?(x, y)
    in_bounds?(x, y) and @state[x][y] != DEAD
  end
  
  # (1P) - MP support requires neighbor counts and identities
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
end
