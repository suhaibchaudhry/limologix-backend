class GeolocationSerializer < ActiveModel::Serializer
  attributes :place, :latitude, :longitude
end
