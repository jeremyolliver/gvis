require 'bundler'
Bundler::GemHelper.install_tasks

require 'appraisal'

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

# Pushes test coverage results to coveralls.io, we will only do this during CI builds
require 'coveralls/rake/task'
Coveralls::RakeTask.new
task :test_with_coveralls => [:test, 'coveralls:push']
