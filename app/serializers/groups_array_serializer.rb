class GroupsArraySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :drivers_count

  def drivers_count
    object.drivers.count
  end
end
