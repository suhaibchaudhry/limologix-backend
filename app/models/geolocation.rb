class Geolocation < ActiveRecord::Base

  belongs_to :locatable, :polymorphic => true

  validates :place, :latitude, :longitude, presence: true

  def calculate_distance(latitude, longitude)
    radius = 3961
    lat1 = to_rad(self.latitude)
    lat2 = to_rad(latitude)
    lon1 = to_rad(self.longitude)
    lon2 = to_rad(longitude)
    dLat = lat2-lat1
    dLon = lon2-lon1

    a = Math::sin(dLat/2) * Math::sin(dLat/2) + Math::cos(lat1) * Math::cos(lat2) * Math::sin(dLon/2) * Math::sin(dLon/2);
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a));
    radius * c
  end

  def to_rad angle
    angle * Math::PI / 180
  end
end
