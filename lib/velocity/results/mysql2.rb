module Velocity
  class Mysql2Result
    class Mysql2MappedRow < MappedRow
  
      def initialize(query)
        @fields = query.fields
        @query = query
        
        # It is imperitive that the adapter return the array in the same sequence of fields provided above
        # If this isn't the case, some re-ordering of the field KEYS should take place
        @fields.each_with_index do |field, index|
          define_singleton_method(field) do
            @tuple[index]
          end
        end
      end
      
      def attributes
        Hash[*@fields.zip(@tuple).flatten]
      end
    end
    
    def initialize(sql, adapter)
      @results = adapter.execute(sql)
      @mapping = Mysql2MappedRow.new(@results)
    end
    
    def collect(&block)
      [].tap do |collected|
        @results.each do |tuple|
          @mapping.tuple = tuple
          collected << yield(@mapping)
        end
      end
    end
    
    def first
      self.[](0)
    end
    
    def [](index)
      # TODO: In need of further optimizations
      @mapping.tap do |mapping|
         # Goofy loop (because we don't have access to [] from the adapter)
         i = -1
         mapping.tuple = @results.detect { |row| i+=1; i == index } or return []
      end
    end
    
    def inspect
      collect(&:attributes).inspect
    end
    
    def to_yaml
      collect(&:attributes).to_yaml
    end
    
    def each(&block)
      @results.each do |tuple|
        @mapping.tuple = tuple
        yield(@mapping)
      end
    end
    
    def length
      @results.count
    end
  end
end
