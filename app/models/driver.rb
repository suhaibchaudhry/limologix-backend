class Driver < ActiveRecord::Base
  include BCrypt
  has_one :address, as: :addressable, dependent: :destroy
  has_many :vehicles, as: :owner, dependent: :destroy

  validates :first_name, :last_name, :password, :mobile_number, :email, presence: true
  validates :mobile_number, :email, uniqueness: true

  before_create :set_auth_token
  before_save :set_password, if: Proc.new { |user| user.password_changed?}

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

  def generate_unique_token_for(attribute)
    token = nil
    loop do
      token = SecureRandom.hex
      break token unless User.send("find_by_#{attribute}", token).present?
    end
  end
end
