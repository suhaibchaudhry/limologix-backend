class Trip < ActiveRecord::Base
  STATUSES = ['active', 'pending']

  scope :active, -> { where(status: 'active') }
  scope :pending, -> { where(status: 'pending') }

  belongs_to :user
  has_one :start_destination, as: :locatable, dependent: :destroy
  has_one :end_destination, as: :locatable, dependent: :destroy

  validates :pick_up_at, :passengers_count, presence: true
  accepts_nested_attributes_for :start_destination
  accepts_nested_attributes_for :end_destination

  STATUSES.each do |value|
    define_method("#{value}?") do
      self.status == value
    end
  end
end
