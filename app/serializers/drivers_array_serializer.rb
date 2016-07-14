class DriversArraySerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :mobile_number, :email, :status
end
