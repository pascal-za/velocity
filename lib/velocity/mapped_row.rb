module Velocity
  class MappedRow
    attr_accessor :tuple
    
    def inspect
      "#Velocity::MappedRow --> #{attributes.inspect}"
    end
  end
end
