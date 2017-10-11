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

task default: %w[test bench]


#
# METRICS
#

metrics_tasks = []

begin
  require 'flog_task'
  FlogTask.new do |t|
    t.threshold = 200
    t.dirs = ['lib']
    t.verbose = true
  end
  metrics_tasks << :flog
rescue LoadError
  warn 'flog_task unavailable'
end

begin
  require 'flay_task'
  FlayTask.new do |t|
    t.verbose = true
    t.dirs = ['lib']
  end
  metrics_tasks << :flay
rescue LoadError
  warn 'flay_task unavailable'
end

begin
  require 'roodi_task'
  RoodiTask.new config: '.roodi.yml', patterns: ['lib/**/*.rb']
  metrics_tasks << :roodi
rescue LoadError
  warn "roodi_task unavailable"
end

desc "Generate code metrics reports"
task code_metrics: metrics_tasks


#
# PROFILING TASKS
#

desc "Show current system load"
task "loadavg" do
  puts File.read "/proc/loadavg"
end

rubylib = "RUBYLIB=lib"
rubyprof = "ruby-prof -m1"
scriptname = "bin/conway_deathmatch"
scriptargs = "-n 100 -s 0 --renderfinal"

desc "Run ruby-prof on bin/conway_deathmatch (100 ticks)"
task "ruby-prof" => "loadavg" do
  sh [rubylib, rubyprof, scriptname, '--', scriptargs].join(' ')
end

desc "Run ruby-prof with --exclude-common-cycles"
task "ruby-prof-exclude" => "ruby-prof" do
  sh [rubylib,
      rubyprof, '--exclude-common-cycles', scriptname, '--',
      scriptargs].join(' ')
end

task "no-prof" do
  sh [rubylib, scriptname, scriptargs].join(' ')
end

#
# GEM BUILD / PUBLISH TASKS
#

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


#
# TRAVIS CI
#

desc "Rake tasks for travis to run"
task travis: %w[test bench no-prof]
