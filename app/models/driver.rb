class Driver < ActiveRecord::Base
  has_one :address, as: :addressable, dependent: :destroy
  has_many :vehicles, as: :owner, dependent: :destroy
end
