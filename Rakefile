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
  # t.warning = true
end

desc "Run benchmarks"
Rake::TestTask.new do |t|
  t.name = "bench"
  t.pattern = "test/bench_*.rb"
  # t.warning = true
end

desc "Generate metrics report"
task :metrics => [:flog, :flay, :roodi] do
end

desc "Run flog on lib/"
task :flog do
  puts
  sh "flog lib | tee metrics/flog"
end

desc "Run flay on lib/"
task :flay do
  puts
  sh "flay lib | tee metrics/flay"
end

desc "Run roodi on lib/"
task :roodi do
  puts
  sh "roodi -config=roodi.yml lib | tee metrics/roodi"
end

# this runs against the installed gem lib, not git / filesystem
desc "Run ruby-prof on 100 iterations of conway_deathmatch"
task "ruby-prof" do
  sh ["ruby-prof -m1 bin/conway_deathmatch -- -n100 -s0 --silent",
      "| tee metrics/ruby-prof"].join(' ')
end
