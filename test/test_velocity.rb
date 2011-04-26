require 'helper'

class TestVelocity < Test::Unit::TestCase
  should "return a Velocity::DataQueryMap with expected API methods when included in an ActiveRecord model" do
    assert_equal(Velocity::DataQueryMap, Foo.data.class)
    
    expected_api_methods = [:select, :joins, :limit, :where, :order]
    
    expected_api_methods.each do |method|
      assert(Foo.data.respond_to?(method), "Velocity::DataQueryMap should respond to #{method}")
      assert_equal(Foo.data, Foo.data.send(method), "Velocity::DataQueryMap.#{method} should return an instance of itself (for chaining)")
    end
  end
end
