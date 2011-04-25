require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'turn'
require 'shoulda'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'velocity'

class TestRoot
  def initialize
    @dir = Dir.pwd
  end
 
  def to_s
    @dir
  end
  
  def join(*args)
    File.join(@dir, args)
  end
end

TEST_ROOT = TestRoot.new

ActiveRecord::Base.establish_connection(YAML::load_file(TEST_ROOT.join('config', 'database.yml')))
Dir[TEST_ROOT.join('test', 'models', '*.rb')].each { |f| require(f) }

unless Foo.table_exists?
  require TEST_ROOT.join('config', 'schema')
end


class Test::Unit::TestCase
end
