class Trip < ActiveRecord::Base
  STATUSES = ['active', 'pending']

  scope :active, -> { where(status: 'active') }
  scope :pending, -> { where(status: 'pending') }

  belongs_to :user

  validates :start_destination, :end_destination, :pick_up_at, :passengers_count, presence: true

  STATUSES.each do |value|
    define_method("#{value}?") do
      self.status == value
    end
  end
end
