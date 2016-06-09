class Customer < ActiveRecord::Base
  belongs_to :user
  has_many :trips

  validates :first_name, :last_name, presence: true

  before_save :set_null_values

  def set_null_values
    self.mobile_number = nil unless mobile_number.present?
    self.email = nil unless email.present?
    self.organisation = nil unless organisation.present?
  end

  def full_name
    [first_name, last_name].join(' ').strip
  end
end