require 'velocity/data_query_map'

module Velocity
  module Query
    extend ActiveSupport::Concern
    
    included do
      @@data = DataQueryMap.new(self)
      cattr_reader :data
    end
  end
end
