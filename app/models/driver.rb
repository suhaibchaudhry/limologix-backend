class Driver < ActiveRecord::Base
  include Authentication

  STATUSES = ['pending', 'approved', 'disapproved', 'blocked']
  SUPER_ADMIN_ACTIONS = {
    approve: 'approved',
    block: 'blocked',
    disapprove: 'disapproved'
  }

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

  validates :first_name, :last_name, :password, :mobile_number, :email, :license_number, :company,
            :license_expiry_date, :license_image, :badge_number, :badge_expiry_date, :ara_image,
            :ara_expiry_date, :insurance_company, :insurance_policy_number, :insurance_expiry_date, presence: true
  validates :mobile_number, :license_number, :badge_number, :email, :channel, :topic, uniqueness: true
  validate :license_image_size, :ara_image_size

  mount_uploader :license_image, ImageUploader
  mount_uploader :ara_image, ImageUploader


  accepts_nested_attributes_for :address

  before_create :set_channel, :set_topic

  SUPER_ADMIN_ACTIONS.each do |action, status|
    define_method("#{action}!") do
      self.status = status
      self.save
    end
  end

  def full_name
    [first_name, last_name].join(' ').strip
  end

  private

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
    self.channel = "driver_#{created_at.to_i}"
  end

  def set_topic
    self.topic = generate_unique_name_for("topic")
  end

  def generate_unique_name_for(attribute)
    name = nil
    loop do
      name = "#{attribute}_#{SecureRandom.hex}"
      break name unless Driver.send("find_by_#{attribute}", name).present?
    end
  end
end