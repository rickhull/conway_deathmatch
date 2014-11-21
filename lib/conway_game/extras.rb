require 'conway_game'

class ConwayGame::BoardState
  module Extras
    # just ignore points out of bounds
    def add_points(points, x_off = 0, y_off = 0, val = ALIVE)
      points.each { |point|
        x = point[0] + x_off
        y = point[1] + y_off
        @state[x][y] = val if self.in_bounds?(x, y)
      }
      self
    end

    # parse a string like "acorn 12 22 block 5 0 p 1 2 p 3 4 p 56 78"
    # add known shapes
    def add_shapes(str, val = ALIVE)
      tokens = str.split
      points = []
      while !tokens.empty?
        shape = tokens.shift
        raise "no coordinates for #{shape}" if tokens.length < 2
        x = tokens.shift.to_i
        y = tokens.shift.to_i
        case shape.downcase
        when 'p'
          points << [x, y]
        else
          known = SHAPES[shape.to_sym]
          if known
            self.add_points(known, x, y, val)
          else
            raise "unknown shape: #{shape}"
          end
        end
      end
      self.add_points(points, 0, 0, val)
    end
    
    # just one of several orientations
    SHAPES = {
      acorn: [
        [0, 2],
        [1, 0],
        [1, 2],
        [3, 1],
        [4, 2],
        [5, 2],
        [6, 2],
      ],
      
      block: [
        [0, 0],
        [0, 1],
        [1, 0],
        [1, 1],
      ],

      beehive: [
        [0, 1],
        [1, 0],
        [1, 2],
        [2, 0],
        [2, 2],
        [3, 1],
      ],

      loaf: [
        [0, 1],
        [1, 0],
        [1, 2],
        [2, 0],
        [2, 3],
        [3, 1],
        [3, 2],
      ],

      boat: [
        [0, 0],
        [0, 1],
        [1, 0],
        [1, 2],
        [2, 1],
      ],

      blinker: [
        [0, 1],
        [1, 1],
        [2, 1],
      ],

      toad: [
        [0, 1],
        [0, 2],
        [1, 3],
        [2, 0],
        [3, 1],
        [3, 2],
      ],
      
      beacon: [
        [0, 0],
        [0, 1],
        [1, 0],
        [2, 3],
        [3, 2],
        [3, 3],
      ],

      glider: [
        [0, 2],
        [1, 0],
        [1, 2],
        [2, 1],
        [2, 2],
      ],

      lwss: [
        [0, 1],
        [0, 3],
        [1, 0],
        [2, 0],
        [3, 0],
        [3, 3],
        [4, 0],
        [4, 1],
        [4, 2],
      ],

      rpent: [
        [0, 1],
        [1, 0],
        [1, 1],
        [1, 2],
        [2, 0],
      ],

      die_hard: [
        [0, 1],
        [1, 1],
        [1, 2],
        [5, 2],
        [6, 0],
        [6, 2],
        [7, 2],
      ],

      block_engine_count: [
        [0, 5],
        [2, 4],
        [2, 5],
        [4, 1],
        [4, 2],
        [4, 3],
        [6, 0],
        [6, 1],
        [6, 2],
        [7, 1],
      ],

      block_engine_space: [
        [0, 0],
        [0, 1],
        [1, 0],
        [1, 3],
        [2, 0],
        [2, 3],
        [2, 4],
        [3, 2],
        [4, 0],
        [4, 2],
        [4, 3],
        [4, 4],
      ],

      block_engine_stripe: [
        [0, 0],
        [1, 0],
        [2, 0],
        [3, 0],
        [4, 0],
        [5, 0],
        [6, 0],
        [7, 0],
        [9, 0],
        [10, 0],
        [11, 0],
        [12, 0],
        [13, 0],
        [17, 0],
        [18, 0],
        [19, 0],
        [26, 0],
        [27, 0],
        [28, 0],
        [29, 0],
        [30, 0],
        [31, 0],
        [32, 0],
        [34, 0],
        [35, 0],
        [36, 0],
        [37, 0],
        [38, 0],
      ],
    }
  end
end
