require 'buildar'

Buildar.new do |b|
  b.gemspec.name = 'conway_deathmatch'
  b.gemspec.summary = "Conway's Game of Life"
  b.gemspec.description = "Deathmatch"
  b.gemspec.author = 'Rick Hull'
  b.gemspec.license = 'GPL'
  b.gemspec.files = ['lib/conway_deathmatch.rb',
                     'lib/conway_deathmatch/shapes.rb',
                     'lib/conway_deathmatch/data/shapes.yaml',
                     'bin/conway_deathmatch']
  # b.gemspec.executables = ['conway_deathmatch']
  b.gemspec.version = '0.0.0.1'
end

require 'rake/testtask'
desc "Run tests"
Rake::TestTask.new

