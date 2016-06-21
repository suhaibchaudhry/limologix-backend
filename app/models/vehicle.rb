class Vehicle < ActiveRecord::Base
  belongs_to :vehicle_type
  belongs_to :vehicle_make
  belongs_to :vehicle_model
  belongs_to :driver
  has_many :features, class_name: 'VehicleFeature', foreign_key: 'vehicle_id'

  validates :license_plate_number, :hll_number, :color, presence: true
  validates :hll_number, :license_plate_number, uniqueness: true

  accepts_nested_attributes_for :features
end
