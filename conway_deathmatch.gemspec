Gem::Specification.new do |s|
  s.name        = 'conway_deathmatch'
  s.version     = File.read(File.join(__dir__, 'VERSION')).chomp
  s.summary     = "Conway's Game of Life"
  s.description = "Deathmatch"
  s.authors     = ["Rick Hull"]
  s.homepage    = 'https://github.com/rickhull/conway_deathmatch'
  s.license     = 'GPL'
  s.files       = [
    'conway_deathmatch.gemspec',
    'VERSION',
    'Rakefile',
    'README.md',
    'lib/conway_deathmatch.rb',
    'lib/conway_deathmatch/board_state.rb',
    'lib/conway_deathmatch/shapes.rb',
    'lib/conway_deathmatch/shapes/classic.yaml',
    'lib/conway_deathmatch/shapes/discovered.yaml',
    'bin/conway_deathmatch',
    'bin/proving_ground',
    'test/bench_board_state.rb',
    'test/spec_helper.rb',
    'test/test_board_state.rb',
    'test/test_shapes.rb',
  ]
  s.executables = ['conway_deathmatch']
  s.add_development_dependency "buildar", "~> 2"
  s.add_development_dependency "minitest", "~> 5"
  s.add_development_dependency "ruby-prof", "~> 0"
  # uncomment and set ENV['CODE_COVERAGE']
  # s.add_development_dependency "simplecov", "~> 0.9.0"
  s.required_ruby_version = "~> 2"
end
