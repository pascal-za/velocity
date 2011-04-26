require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
require 'jeweler'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "velocity"
  gem.homepage = "http://github.com/pascalh1011/velocity"
  gem.license = "MIT"
  gem.summary = %Q{Provides a barebones, but supremely quick way of querying your ActiveRecord database.}
  gem.description = %Q{Provides a barebones, but supremely quick way of querying your ActiveRecord database.}
  gem.email = "101pascal@gmail.com"
  gem.authors = ["Pascal Houliston"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :migrate do
  require File.join(File.dirname(__FILE__), 'test', 'helper')
  require 'active_record'
  load TEST_ROOT.join('db', 'migrations.rb')
end

task :default => :test

