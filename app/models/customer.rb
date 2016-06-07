class Customer < ActiveRecord::Base
  belongs_to :user
  has_many :trips

  validates :first_name, :last_name, presence: true
end