require 'velocity/result'

module Velocity
  class DataQueryMap
    def initialize(model_binding)
      @model = model_binding
      @results = nil # For accepting last query (from Result)
     
      # Prepare and proxy methods pertaining to results onto the Result object (after performing the query)
      (Result.instance_methods-Result.superclass.instance_methods).each do |method|
        define_singleton_method(method) do 
          prepare_and_run_query
          @results.send(method)
        end
      end
      
    end
    
    def select
      self
    end
    
    def limit
      self
    end
    
    def where
      self
    end
    
    def joins
      self
    end
    
    private
    def prepare_and_run_query
    
    end
  end
end
