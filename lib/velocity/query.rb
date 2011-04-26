require 'velocity/data_query_map'

module Velocity
  module Query
    extend ActiveSupport::Concern
    
    included do
      cattr_accessor :data
      self.data = DataQueryMap.new(self)
    end
  end
end
