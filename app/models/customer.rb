class Customer < ActiveRecord::Base
  belongs_to :user

  validates :first_name, :last_name, :mobile_number, presence: true
  validates :mobile_number, uniqueness: true
end