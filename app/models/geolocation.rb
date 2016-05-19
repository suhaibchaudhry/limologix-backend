class Geolocation < ActiveRecord::Base

  belongs_to :locatable, :polymorphic => true

  validates :name, :latitude, :longitude, presence: true
end
