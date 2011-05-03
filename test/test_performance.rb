require 'helper'

class TestPerformance < Test::Unit::TestCase
  def measure(&block)
    t = Time.now.to_f
    yield
    ((Time.now.to_f-t)*1000.0).round
  end
  
  # TODO: Nice way of getting actual memory consumption
  def memory
    return 0 unless RUBY_PLATFORM.match(/linux/i) # Will be happy to remove this if someone can confirm it's working on other OS's :)
    sleep 0.1
    `ps -o rss= -p #{Process.pid}`.to_i
  end


  should "perform favourably compared to ActiveRecord" do
    #return
    t = table
    t.headings = ['Name', 'Total Rows', 'Total Processing Time (ms)', 'Memory Consumed (KB)']
    count = Foo.count('id')
    base = memory
    private_set = nil
    
    ar = measure do
      collection = []    
      Foo.find_each do |result|
        collection << result.some_integer_field
      end
      private_set=memory-base
      collection
    end
    t << ['ActiveRecord', count, ar, private_set]
  
    base = memory
    v = measure do
      collection = []
      Foo.data.each do |result|
        collection << result.some_integer_field
      end     
      private_set = memory-base
      collection
    end
    t << ['Velocity', count, v, private_set]
    puts t    
  end
end
