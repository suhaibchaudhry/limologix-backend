class LimoCompany < ActiveRecord::Base
  has_many :users
  has_one :address, as: :addressable, dependent: :destroy
  validates :name, :uid, :email, :primary_phone_number, :logo, presence: true
  validates :email, :uid, uniqueness: true

  validate :logo_size

  mount_uploader :logo, LogoUploader
  accepts_nested_attributes_for :address

  private

  def logo_size
    if logo.size > 5.megabytes
      errors.add(:logo, "size should be less than 5MB")
    end
  end
end
