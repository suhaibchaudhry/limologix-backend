class VehicleMake < ActiveRecord::Base
  has_many :vehicle_make_types, dependent: :destroy
  has_many :vehicle_types, through: :vehicle_make_types, source: :vehicle_type

  has_many :vehicle_models, through: :vehicle_make_types, source: :vehicle_models
end
