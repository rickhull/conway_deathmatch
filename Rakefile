require 'buildar'

Buildar.new do |b|
  b.gemspec_file = 'conway_deathmatch.gemspec'
  b.version_file = 'VERSION'
end

task default: %w[test bench]

require 'rake/testtask'
desc "Run tests"
Rake::TestTask.new do |t|
  t.name = "test"
  t.pattern = "test/test_*.rb"
  t.warning = true
end

desc "Run benchmarks"
Rake::TestTask.new do |t|
  t.name = "bench"
  t.pattern = "test/bench_*.rb"
#  t.loader = :testrb
  t.warning = true
end
