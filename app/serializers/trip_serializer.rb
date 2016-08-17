class TripSerializer < ActiveModel::Serializer
  attributes :id, :start_destination, :end_destination, :pick_up_at, :passengers_count, :status
  has_one :start_destination, serializer: GeolocationSerializer
  has_one :end_destination, serializer: GeolocationSerializer
  has_one :customer
  has_one :vehicle_type


  def attributes
    hash = super
    if object.active?
      driver = object.active_dispatch.driver
      hash[:driver] = DriverVehicleSerializer.new(driver).serializable_hash
    end
    hash
  end

  def vehicle_type
    {
      id: object.vehicle_type.id,
      name: object.vehicle_type.name
    }
  end
end
