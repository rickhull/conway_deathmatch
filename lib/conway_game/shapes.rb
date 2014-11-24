require 'conway_game'
require 'yaml'

module ConwayGame
  module Shapes
    @@known

    # memoize lib/conway_game/data/shapes.yaml
    def self.known
      @@known ||= YAML.load_file(File.join(__dir__, 'data', 'shapes.yaml'))
    end

    # parse a string like "acorn 12 22 block 5 0 p 1 2 p 3 4 p 56 78"
    # add known shapes
    def self.add(board, str, val = BoardState::ALIVE)
      tokens = str.split
      points = []
      known = self.known
      
      while !tokens.empty?
        shape = tokens.shift.downcase
        raise "no coordinates for #{shape}" if tokens.length < 2
        x = tokens.shift.to_i
        y = tokens.shift.to_i
        case shape.downcase
        when 'p'
          points << [x, y]
        else
          board.add_points(known.fetch(shape), x, y, val)
        end
      end
      board.add_points(points, 0, 0, val)
    end
  end
end
