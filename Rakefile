require 'rake/testtask'

desc "Run tests"
Rake::TestTask.new do |t|
  t.name = "test"
  t.pattern = "test/*.rb"
  # t.warning = true
end

desc "Run benchmarks"
Rake::TestTask.new do |t|
  t.name = "bench"
  t.pattern = "bench/*.rb"
  # t.warning = true
end

task default: :test

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
    t.dirs = ['lib']
    t.verbose = true
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
# PROFILING
#

desc "Show current system load"
task "loadavg" do
  puts File.read "/proc/loadavg"
end

def lib_sh(cmd)
  sh "RUBYLIB=lib #{cmd}"
end

def rprof_sh(script, args, rprof_args = '')
  lib_sh ['ruby-prof', rprof_args, script, '--', args].join(' ')
end

rprof_args = "-m1"
xname = "bin/conway_deathmatch"
xargs = "-n 100 -s 0 --renderfinal"

desc "Run ruby-prof on bin/conway_deathmatch (100 ticks)"
task "ruby-prof" => "loadavg" do
  rprof_sh xname, xargs, rprof_args
end

desc "Run ruby-prof with --exclude-common-cycles"
task "ruby-prof-exclude" => "ruby-prof" do
  rprof_sh xname, xargs, "#{rprof_args} --exclude-common-cycles"
end

task "no-prof" do
  lib_sh [xname, xargs].join(' ')
end

#
# GEM BUILD / PUBLISH
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
task travis: %w[test no-prof]
