class Admin < ActiveRecord::Base
  include BCrypt

  validates :first_name, :last_name, :email, :password , presence: true
  validates :email, uniqueness: true

  before_create :set_auth_token
  before_save :set_password, if: Proc.new { |user| user.password_changed?}

  def auth_token_expired?
    DateTime.now >= self.auth_token_expires_at
  end

  def update_auth_token!
    set_auth_token
    save
  end

  def verify_password?(password)
    Password.new(self.password) == password
  end

  private

  def set_password
    self.password = encrypt_password(password)
  end

  def set_auth_token
    self.auth_token = generate_unique_token_for("auth_token")
    self.auth_token_expires_at = DateTime.now + 1.day
  end

  def encrypt_password(password)
    Password.create(password) if password.present?
  end

  def generate_unique_token_for(attribute)
    token = nil
    loop do
      token = SecureRandom.hex
      break token unless Admin.send("find_by_#{attribute}", token).present?
    end
  end
end
