require 'velocity/data_query_map'

module Velocity
  module Query
    extend ActiveSupport::Concern

    module ClassMethods
      def data
        return DataQueryMap.new(self)
      end
    end
  end
end
