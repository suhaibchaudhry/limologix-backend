class VehicleSerializer < ActiveModel::Serializer
  attributes :id, :license_plate_number, :hll_number, :color, :vehicle_model, :vehicle_type, :vehicle_make, :features
  has_one :vehicle_type
  has_one :vehicle_make
  has_one :vehicle_model

  def features
    object.features.collect(&:name)
  end
end

