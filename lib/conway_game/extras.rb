require 'conway_game'
require 'yaml'

class ConwayGame::BoardState
  module Extras
    @@known_shapes = nil

    # just ignore points out of bounds
    def add_points(points, x_off = 0, y_off = 0, val = ALIVE)
      points.each { |point|
        x = point[0] + x_off
        y = point[1] + y_off
        @state[x][y] = val if self.in_bounds?(x, y)
      }
      self
    end

    # memoize lib/conway_game/data/shapes.yaml
    def known_shapes
      @@known_shapes ||=
        YAML.load_file(File.join(__dir__, 'data', 'shapes.yaml'))
    end

    # parse a string like "acorn 12 22 block 5 0 p 1 2 p 3 4 p 56 78"
    # add known shapes
    def add_shapes(str, val = ALIVE)
      tokens = str.split
      points = []
      while !tokens.empty?
        shape = tokens.shift.downcase
        raise "no coordinates for #{shape}" if tokens.length < 2
        x = tokens.shift.to_i
        y = tokens.shift.to_i
        case shape.downcase
        when 'p'
          points << [x, y]
        else
          if (known = self.known_shapes[shape])
            self.add_points(known, x, y, val)
          else
            raise "unknown shape: #{shape}"
          end
        end
      end
      self.add_points(points, 0, 0, val)
    end
  end
end
