class Trip < ActiveRecord::Base
  STATUSES = ['active', 'pending', 'closed', 'cancelled']

  scope :active, -> { where(status: 'active') }
  scope :pending, -> { where(status: 'pending') }
  scope :closed, -> { where(status: 'closed') }
  scope :cancelled, -> { where(status: 'closed') }

  belongs_to :user
  belongs_to :customer
  belongs_to :vehicle_type

  has_one :start_destination, as: :locatable, dependent: :destroy
  has_one :end_destination, as: :locatable, dependent: :destroy

  has_one :dispatch
  has_one :driver, through: :dispatch, source: :driver

  validates :pick_up_at, :passengers_count, presence: true
  accepts_nested_attributes_for :start_destination
  accepts_nested_attributes_for :end_destination

  STATUSES.each do |value|
    define_method("#{value}?") do
      self.status == value
    end
  end

  def update_status_to_active!
    self.status = 'active'
    save
  end

  def update_status_to_cancelled!
    self.status = 'cancelled'
    save
  end

end
