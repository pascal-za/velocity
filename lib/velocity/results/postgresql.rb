module Velocity
  class PostgreSQLResult
    def initialize(sql, adapter)
      @results = adapter.execute(sql)
      @mapping = MappedRow.new(@results.fields)
    end
    
    def collect(&block)
      @collected = []    
      @results.each do |row|
        @collected << yield(@mapping.__apply_context(row))
      end
      cleanup
      @collected
    end
    
    def first
      @mapping.__apply_context(@results[0]).tap { cleanup }
    end
    
    def [](index)
      @mapping.__apply_context(@results[index])
    end
    
    def each(&block)
      @results.each do |row|
        yield(@mapping.__apply_context(row))
      end
      cleanup
    end
    
    def length
      @results.num_tuples
    end
    
    def cleanup
      @results.clear
    end
  end
end
