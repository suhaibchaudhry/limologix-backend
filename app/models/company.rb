class Company < ActiveRecord::Base
  has_many :users
  has_many :customers, through: :users
  has_one :address, as: :addressable, dependent: :destroy

  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validate :logo_size

  mount_uploader :logo, ImageUploader
  accepts_nested_attributes_for :address

  private

  def logo_size
    if logo.size > 5.megabytes
      errors.add(:logo, "size should be less than 5MB")
    end
  end
end