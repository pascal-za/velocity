class Bar < ActiveRecord::Base
  belongs_to :foo
  
  include Velocity::Query
end
