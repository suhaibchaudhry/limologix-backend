class Company < ActiveRecord::Base
  has_many :users
  has_many :customers
  has_one :address, as: :addressable, dependent: :destroy

  validates :name, :email, presence: { message: -> (object, data) do
      "#{data[:model]} #{data[:attribute].downcase} can't be blank"
    end
  }
  validates :email, uniqueness: { message: -> (object, data) do
      "#{data[:model]} #{data[:attribute].downcase} has already been taken"
    end
  }
  validate :logo_size

  mount_uploader :logo, LogoUploader
  accepts_nested_attributes_for :address

  private

  def logo_size
    if logo.size > 5.megabytes
      errors.add(:logo, "Company logo size should be less than 5MB")
    end
  end
end
