require 'buildar'

Buildar.new do |b|
  b.gemspec_file = 'conway_deathmatch.gemspec'
  b.version_file = 'VERSION'
end

task default: %w[test]

require 'rake/testtask'
desc "Run tests"
Rake::TestTask.new do |t|
  t.pattern = "test/*.rb"
end
