class Driver < ActiveRecord::Base
  include Authentication

  STATUSES = ['pending', 'approved', 'disapproved', 'blocked']

  STATUSES.each do |status|
    scope status.to_sym, -> { where(status: status) }

    define_method("#{status}?") do
      self.status == status
    end
  end

  scope :visible, -> { where( visible: true ) }
  scope :invisible, -> { where( visible: false ) }

  has_one :address, as: :addressable, dependent: :destroy
  has_one :vehicle, dependent: :destroy

  has_many :dispatches
  has_one  :active_dispatch, -> { where('status IN (?)', ['yet_to_start','started'])}, class_name: 'Dispatch'

  validates :first_name, :last_name, :password, :mobile_number, :email, :license_number,
            :license_expiry_date, :license_image, :badge_number, :badge_expiry_date, :ara_image,
            :ara_expiry_date, :insurance_company, :insurance_policy_number, :insurance_expiry_date, presence: true
  validates :mobile_number, :license_number, :badge_number, :email, uniqueness: true
  validate :license_image_size, :ara_image_size

  mount_uploader :license_image, ImageUploader
  mount_uploader :ara_image, ImageUploader


  accepts_nested_attributes_for :address

  before_create :set_channel

  def approve!
    update_status!('approved')
  end

  def disapprove!
    update_status!('disapproved')
  end

  def block!
    update_status!('blocked')
  end

  def full_name
    [first_name, last_name].join(' ').strip
  end

  private

  def update_status!(status)
    self.status = status
    self.save
  end

  def license_image_size
    if license_image.size > 5.megabytes
      errors.add(:license_image, "size should be less than 5MB")
    end
  end

  def ara_image_size
    if ara_image.size > 5.megabytes
      errors.add(:ara_image, "size should be less than 5MB")
    end
  end

  def set_channel
    self.channel = generate_unique_token_for("channel")
  end
end
