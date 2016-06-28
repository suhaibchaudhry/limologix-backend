class Driver < ActiveRecord::Base
  include BCrypt

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
  has_one :vehicle

  has_many :dispatches
  has_one  :active_dispatch, -> { where('status IN (?)', ['yet_to_start','started'])}, class_name: 'Dispatch'

  validates :first_name, :last_name, :password, :mobile_number, :email, :license_number,
            :license_expiry_date, :license_image, :badge_number, :badge_expiry_date, :ara_image,
            :ara_expiry_date, :insurance_company, :insurance_policy_number, :insurance_expiry_date, presence: true
  validates :mobile_number, :license_number, :badge_number, :email, uniqueness: true
  validate :license_image_size, :ara_image_size
  validates :mobile_number, numericality: { only_integer: true }
  validates :email, format: { with: /\A[^\s@]+@[^\s@]+\.[^\s@]{2,}\z/, message: "is invalid" }

  mount_uploader :license_image, ImageUploader
  mount_uploader :ara_image, ImageUploader


  accepts_nested_attributes_for :address

  before_create :set_auth_token, :set_channel
  before_save :set_password, if: Proc.new { |user| user.password_changed?}

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

  def verify_password?(password)
    Password.new(self.password) == password
  end

  def auth_token_expired?
    DateTime.now >= self.auth_token_expires_at
  end

  def password_token_expired?
    DateTime.now >= self.reset_password_sent_at
  end

  def update_auth_token!
    set_auth_token
    save
  end

  def update_reset_password_token!
    set_password_token
    save
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

  def set_password
    self.password = encrypt_password(password)
  end

  def set_auth_token
    self.auth_token = generate_unique_token_for("auth_token")
    self.auth_token_expires_at = DateTime.now + 1.day
  end

  def set_password_token
    self.reset_password_token = generate_unique_token_for("reset_password_token")
    self.reset_password_sent_at = DateTime.now + 1.day
  end

  def encrypt_password(password)
    Password.create(password) if password.present?
  end

  def set_channel
    self.channel = generate_unique_token_for("channel")
  end

  def generate_unique_token_for(attribute)
    token = nil
    loop do
      token = SecureRandom.hex
      break token unless Driver.send("find_by_#{attribute}", token).present?
    end
  end
end
