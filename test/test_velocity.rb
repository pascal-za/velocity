require 'helper'

class TestVelocity < Test::Unit::TestCase
  def setup
    @foo_a = Foo.create(:some_string_field => "Value A")
    @foo_b = Foo.create(:some_string_field => "Value A", :another_string_field => "Value B")
    @foo_a.bars.create(:a_string_field => "A")
    @foo_b.bars.create(:a_string_field => "B")
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
    assert(first_match.inspect.include?("Value A"))

    second_match = Foo.data.where(:some_string_field => "Value A").where(:another_string_field => "Value B").first

    Foo.columns_hash.keys.each do |column|
      assert(second_match.respond_to?(column), "Single result should respond to column #{column}")
    end
    assert_equal("Value A", second_match.some_string_field)
    assert_equal("Value B", second_match.another_string_field)
  end
  
  should "return an iterator for all results" do
    results_via_reflection = Foo.data.where(:some_string_field => "Value A")
    results_via_iterator = Foo.data.where(:some_string_field => "Value A").all # Note the all()
    
    [results_via_reflection, results_via_iterator].each do |results|
      results.each do |result|
       Foo.columns_hash.keys.each do |column|
         assert(result.respond_to?(column), "Single result should respond to column #{column}")
         assert_equal(result.some_string_field, "Value A")
       end
      end
    end
    assert_equal(2, results_via_iterator.length)
  end
  
  should "respond provide a simple inspection API for debugging" do
    all_results = Foo.data.where(:some_string_field => "Value A")

    assert(all_results.inspect.include?('Value B'), "inspect() method should work as per default")
    assert(all_results.to_yaml.include?('Value B'), "to_yaml() method should work as per default")
  end
  
  should "return results in the correct order" do
    results = Foo.data.where(:some_string_field => "Value A").order("another_string_field ASC").collect { |r| r.another_string_field }
    
    assert_equal("Value B", results.first)
    assert_nil(results.last)
  end
  
  should "join associations when requested and return appropriate columns" do
    results = Foo.data.where(:some_string_field => "Value A").joins(:bars)
    
    results.each do |result|
      Foo.columns_hash.merge(Bar.columns_hash).keys.each do |column|
        assert(result.respond_to?(column), "Result should respond to #{column} (may be from association)")
      end
      assert(result.respond_to?("bars_id"), "Should include the association's primary key")
    end
  end
  
  should "inform the user if their database is unsupported" do
    assert_raise RuntimeError do
      Velocity::DataQueryMap.new(Foo, "HappyRainbowAdapter")
    end
  end
end
