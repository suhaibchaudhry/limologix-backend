class LimoCompany < ActiveRecord::Base
  has_many :users
  has_one :address, as: :addressable, dependent: :destroy
  validates :name, :uid, :email, :primary_phone_number, presence: true
  validates :email, :uid, uniqueness: true

  mount_uploader :logo, LogoUploader
  accepts_nested_attributes_for :address
end
