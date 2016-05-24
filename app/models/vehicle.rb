class Vehicle < ActiveRecord::Base
  belongs_to :vehicle_type
  belongs_to :owner , polymorphic: true
end
