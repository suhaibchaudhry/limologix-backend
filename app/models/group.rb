class Group < ActiveRecord::Base
  belongs_to :company
  has_many :driver_groups, dependent: :destroy
  has_many :drivers, through: :driver_groups

  validates :name, presence: true
end
