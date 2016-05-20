class Geolocation < ActiveRecord::Base

  belongs_to :locatable, :polymorphic => true

  validates :place, :latitude, :longitude, presence: true
end
