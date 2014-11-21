require 'conway_game'

class ConwayGame::BoardState
  module Multiplayer
    def mp_tick
      new_state = self.class.new_state(@xr.last, @yr.last)
      @xr.each { |x|
        @yr.each { |y|
          new_state[x][y] = mp_next_value(x, y)
        }
      }
      @state = new_state
      self
    end    

    def mp_next_value(x, y)
      n, birthright = mp_neighbor_stats(x, y)
      if alive?(x, y)
        (n == 2 or n == 3) ? birthright : DEAD
      else
        (n == 3) ? birthright : DEAD
      end
    end

    def mp_neighbor_stats(x, y)
      count = 0
      mp_majority = {}
      (x-1..x+1).each { |xn|
        (y-1..y+1).each { |yn|
          next if xn == x and yn == y # don't count self
          if alive?(xn, yn)
            val = @state[xn][yn]
            count += 1
            mp_majority[val] ||= 0
            mp_majority[val] += 1
          end
        }
      }
      largest = 0
      birthright = nil
      mp_majority.each { |k, v|
        if v > largest
          birthright = k
          largest = v
        elsif v == largest
          birthright = k if rand(2).zero?
        end
      }
      [count, birthright]
    end
  end
end
