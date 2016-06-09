class Vehicle < ActiveRecord::Base
  belongs_to :vehicle_type
  belongs_to :driver

  validates :make, :model, :license_plate_number, :hll_number, :color, presence: true
end
