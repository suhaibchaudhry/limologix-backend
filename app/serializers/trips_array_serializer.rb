class TripsArraySerializer < ActiveModel::Serializer
  attributes :id, :start_destination, :end_destination, :pick_up_at, :passengers_count, :status
  has_one :start_destination, serializer: GeolocationSerializer
  has_one :end_destination, serializer: GeolocationSerializer
  has_one :customer
end
