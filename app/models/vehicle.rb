class Vehicle < ActiveRecord::Base
  belongs_to :vehicle_model
  belongs_to :owner , polymorphic: true
end
