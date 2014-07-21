#!/usr/bin/env rake
# Rakefile - automate common tasks. For list of tasks run ./Rakefile -T

# ensure load path includes discoteq
require 'pathname'
lib_path = Pathname.new(__FILE__).join('../lib').expand_path.to_s
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include? lib_path

# cleanliness is next to ${DEITY}ness
require 'rake/clean'

# include tasks for building and publishing this gem
require 'bundler/gem_tasks'
CLOBBER << 'pkg'

# unit testing
require 'rake/testtask'
Rake::TestTask.new do |t|
  t.test_files = FileList['test/unit/**/test_*.rb']
end

# rubocop style and correctness testing
require 'rubocop/rake_task'
RuboCop::RakeTask.new do |t|
  t.formatters = ['clang']
end
CLOBBER << 'coverage'

# chef-client integration testing
require 'kitchen/rake_tasks'
Kitchen::RakeTasks.new
# ensure test cookbooks have access to the recently built gem
require 'discoteq/version'
test_cookbook = 'test/cookbooks/discoteq-test'
test_cookbook_gem = "#{test_cookbook}/files/default/discoteq.gem"
file test_cookbook_gem => :build do
  mkdir_p File.dirname test_cookbook_gem
  cp "pkg/discoteq-#{Discoteq::VERSION}.gem", test_cookbook_gem
end
task 'kitchen:default-ubuntu-1204' => test_cookbook_gem
task 'kitchen:all' => test_cookbook_gem

# define common high-level tasks with short names
desc 'test integrations with supported frameworks'
task test_integration: 'kitchen:all'

desc 'lint for correctness and style'
task lint: :rubocop
task default: %w(lint test)
task all: %w(lint test test_integration build)
