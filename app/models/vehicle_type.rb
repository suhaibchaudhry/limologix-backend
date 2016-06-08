class VehicleType < ActiveRecord::Base
  has_many :vehicles

  validates :name, :description, :image, :capacity, presence: true
  validate :image_size

  mount_uploader :image, ImageUploader

  private

  def image_size
    if image.size > 5.megabytes
      errors.add(:image, "size should be less than 5MB")
    end
  end
end
