class Foo < ActiveRecord::Base
  has_many :bars
  
  include Velocity::Query
end
