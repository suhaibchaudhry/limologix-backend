class Advertisement < ActiveRecord::Base
  validates :poster, presence: true
  validate :poster_size

  mount_uploader :poster, ImageUploader

  private
  def poster_size
    if poster.size > 5.megabytes
      errors.add(:poster, "size should be less than 5MB")
    end
  end
end
