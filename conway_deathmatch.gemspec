Gem::Specification.new do |s|
  s.name        = 'conway_deathmatch'
  s.summary     = "Conway's Game of Life, Deathmatch Edition (tm)"
  s.description = "Several distinct populations competing for survival"
  s.authors     = ["Rick Hull"]
  s.homepage    = 'https://github.com/rickhull/conway_deathmatch'
  s.license     = 'GPL'

  s.required_ruby_version = ">= 2"
  s.version     = File.read(File.join(__dir__, 'VERSION')).chomp

  s.files  = %w[conway_deathmatch.gemspec VERSION Rakefile README.md]
  s.files += Dir['lib/**/*.rb']
  s.files += Dir['test/**/*.rb']
  s.files += Dir['bin/**/*.rb']
  s.executables = ['conway_deathmatch']

  s.add_runtime_dependency "slop", "~> 4.0"
end
