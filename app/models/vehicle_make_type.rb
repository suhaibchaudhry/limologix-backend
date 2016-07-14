class VehicleMakeType < ActiveRecord::Base
  belongs_to :vehicle_make
  belongs_to :vehicle_type

  has_many :vehicle_models, dependent: :destroy
end
