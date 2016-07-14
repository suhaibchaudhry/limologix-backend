class VehicleModel < ActiveRecord::Base
  belongs_to :vehicle_make_type
  has_one :vehicle_type, through: :vehicle_make_type, source: :vehicle_type
  has_one :vehicle_model, through: :vehicle_make_type, source: :vehicle_model
end
