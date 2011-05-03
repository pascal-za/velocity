module Velocity
  class PostgreSQLResult
    class PostgreSQLMappedRow < MappedRow
  
      def initialize(pg_query)
        @fields = pg_query.fields
        @pg_query = pg_query
        
        # It is imperitive that the adapter return the array in the same sequence of fields provided above
        # If this isn't the case, some re-ordering of the field KEYS should take place
        @fields.each_with_index do |field, index|
          define_singleton_method(field) do
            pg_query.getvalue(@tuple, index)
          end
        end
      end
      
      def attributes
        @pg_query[@tuple] # Try to avoid calling this, its relatively slow.
      end
    end
    
    def initialize(sql, adapter)
      @results = adapter.execute(sql)
      @mapping = PostgreSQLMappedRow.new(@results)
      @num_tuples = @results.num_tuples
    end
    
    def collect(&block)
      @collected = []    
      @results.num_tuples.times do |tuple|
        @mapping.tuple = tuple
        @collected << yield(@mapping)
      end
      cleanup
      @collected
    end
    
    def first
      self.[](0)
    end
    
    def [](index)
      @mapping.tap do |mapping|
        mapping.tuple = index
      end
    end
    
    def inspect
      collect(&:attributes).inspect
    end
    
    def to_yaml
      collect(&:attributes).to_yaml
    end
    
    def each(&block)
      @results.num_tuples.times do |tuple|
        @mapping.tuple = tuple
        yield(@mapping)
      end
      cleanup
    end
    
    def length
      @num_tuples
    end
    
    def cleanup
      @results.clear
    end
  end
end
