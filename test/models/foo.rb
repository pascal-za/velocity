class Foo < ActiveRecord::Base
  has_many :bars, :dependent => :destroy
  
  include Velocity::Query
end
