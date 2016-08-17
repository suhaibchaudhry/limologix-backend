class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  has_many :drivers, serializer: DriversArraySerializer
end
