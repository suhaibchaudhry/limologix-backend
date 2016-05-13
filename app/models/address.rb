class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true
  validates :city, presence: true
end
