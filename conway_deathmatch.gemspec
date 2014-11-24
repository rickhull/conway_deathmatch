Gem::Specification.new do |s|
  s.name        = 'conway_deathmatch'
  s.summary     = "Conway's Game of Life"
  s.description = "Deathmatch"
  s.authors     = ["Rick Hull"]
  s.license     = 'GPL'
  s.files       = ['lib/conway_deathmatch.rb',
                   'lib/conway_deathmatch/shapes.rb',
                   'lib/conway_deathmatch/data/shapes.yaml',
                   'bin/conway_deathmatch']
  s.executables = ['conway_deathmatch']
  s.homepage    = 'https://github.com/rickhull/conway_deathmatch'
  s.version     = File.read(File.join(__dir__, 'VERSION')).chomp
end
