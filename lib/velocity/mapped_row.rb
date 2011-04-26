module Velocity
  class MappedRow
    def initialize(fields)
      fields.each do |field|
        define_singleton_method(field) do
          @tuple[field]
        end
      end
    end
    
    alias :inspect :to_s
    
    def inspect
      "#Velocity::MappedRow --> #{@tuple.inspect}"
    end
    
    def __apply_context(tuple)
      @tuple = tuple
      self
    end
  end
end
