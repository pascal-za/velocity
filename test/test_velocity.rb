require 'helper'

class TestVelocity < Test::Unit::TestCase
  def setup
    @foo_a = Foo.create(:some_string_field => "Value A")
    @foo_b = Foo.create(:some_string_field => "Value A", :another_string_field => "Value B")
  end
  
  def teardown
    @foo_a.destroy
    @foo_b.destroy
  end
  
  should "return a Velocity::DataQueryMap with expected API methods when included in an ActiveRecord model" do
    assert_equal(Velocity::DataQueryMap, Foo.data.class)
    
    expected_api_methods = [:select, :joins, :limit, :where, :order]
    
    expected_api_methods.each do |method|
      assert(Foo.data.respond_to?(method), "Velocity::DataQueryMap should respond to #{method}")
      instance = Foo.data
      assert_equal(instance, instance.send(method), "Velocity::DataQueryMap.#{method} should return an instance of itself (for chaining)")
    end
  end
  
  should "return the first result matching when given a where clause" do
     first_match = Foo.data.where(:some_string_field => "Value A").first
     Foo.columns_hash.keys.each do |column|
       assert(first_match.respond_to?(column), "Single result should respond to column #{column}")
     end
     assert_equal("Value A", first_match.some_string_field)
  end
end
