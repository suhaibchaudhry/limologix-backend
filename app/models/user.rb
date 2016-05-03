require 'bcrypt'
class User < ActiveRecord::Base
  include BCrypt
  belongs_to :role
  belongs_to :limo_company

  validates :first_name, :last_name, :user_name, :password, :mobile_number, :auth_token, presence: true
  validates :user_name, :password, :mobile_number, :auth_token, uniqueness: true

  before_create :encrypt_password
  before_validation :generate_auth_token

  def verify_password?(password)
    Password.new(self.password) == password
  end

  def auth_token_expired?
    DateTime.now >= self.auth_token_expires_at
  end

  def update_auth_token
    generate_auth_token
    save
  end

  private

  def encrypt_password
    self.password = Password.create(password)if password.present?
  end

  def generate_auth_token
    token = nil
    loop do
      token = SecureRandom.hex
      break token unless User.where(auth_token: token).first
    end
    self.auth_token = token if token.present?
    self.auth_token_expires_at = DateTime.now+1.day
  end
end
