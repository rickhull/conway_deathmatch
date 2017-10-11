task default: %w[test bench]
task travis: %w[test bench ruby-prof]

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

desc "Generate code metrics reports"
task :code_metrics => [:flog, :flay, :roodi] do
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

begin
  require 'roodi_task'
  params = {
    config: '.roodi.yml',
    patterns: ['lib/**/*.rb'],
  }
  # params = {}
  r = RoodiTask.new params
rescue LoadError
  warn "roodi_task unavailable"
end

desc "Show current system load"
task "loadavg" do
  puts File.read "/proc/loadavg"
end

desc "Run ruby-prof on bin/conway_deathmatch (100 ticks)"
task "ruby-prof" => "loadavg" do
  sh ["RUBYLIB=lib ruby-prof -m1 bin/conway_deathmatch",
      "-- -n 100 -s 0 --renderfinal",
     ].join(' ')
end

desc "Run ruby-prof with --exclude-common-cycles"
task "ruby-prof-exclude" => "ruby-prof" do
  sh ["ruby-prof -m1 --exclude-common-cycles bin/conway_deathmatch",
      "-- -n 100 -s 0 --renderfinal",
     ].join(' ')
end

begin
  require 'buildar'

  Buildar.new do |b|
    b.gemspec_file = 'conway_deathmatch.gemspec'
    b.version_file = 'VERSION'
    b.use_git = true
  end
rescue LoadError
  # ok
end
