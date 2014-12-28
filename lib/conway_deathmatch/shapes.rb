require 'conway_deathmatch'
require 'yaml'

module ConwayDeathmatch::Shapes
  def self.load_yaml(filename)
    YAML.load_file(File.join(__dir__, 'shapes', filename))
  end

  # memoize shapes/classic.yaml
  def self.classic
    @@classic ||= self.load_yaml('classic.yaml')
  end

  # memoize shapes/discovered.yaml
  def self.discovered
    @@disovered ||= self.load_yaml('discovered.yaml')
  end

  # parse a string like "acorn 12 22 block 5 0 p 1 2 p 3 4 p 56 78"
  # add known shapes
  def self.add(grid, str, val = ConwayDeathmatch::ALIVE)
    tokens = str.split
    points = []
    classic = self.classic

    while !tokens.empty?
      shape = tokens.shift.downcase
      raise "no coordinates for #{shape}" if tokens.length < 2
      x = tokens.shift.to_i
      y = tokens.shift.to_i
      case shape.downcase
      when 'p'
        points << [x, y]
      else
        found = classic[shape] || self.discovered.fetch(shape)
        grid.add_points(found, x, y, val)
      end
    end
    grid.add_points(points, 0, 0, val)
  end
end
