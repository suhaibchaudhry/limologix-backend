class DriversArraySerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :mobile_number, :company, :email, :status, :vehicle_type

  def vehicle_type
    object.vehicle.vehicle_type.name
  end
end
