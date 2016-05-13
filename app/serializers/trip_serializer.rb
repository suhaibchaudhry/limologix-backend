class TripSerializer < ActiveModel::Serializer
  attributes :id, :start_destination, :end_destination, :pick_up_at
end
