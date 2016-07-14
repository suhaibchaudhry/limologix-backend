class TripSerializer < ActiveModel::Serializer
  attributes :id, :start_destination, :end_destination, :pick_up_at, :passengers_count
  has_one :start_destination, serializer: GeolocationSerializer
  has_one :end_destination, serializer: GeolocationSerializer
  has_one :customer
end
