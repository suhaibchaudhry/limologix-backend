class Driver < ActiveRecord::Base
  include Authentication

  attr_accessor :card_number, :card_expiry_date, :card_code

  STATUSES = ['pending', 'approved', 'disapproved', 'blocked']
  SUPER_ADMIN_ACTIONS = {
    approve: 'approved',
    block: 'blocked',
    disapprove: 'disapproved'
  }
  DEFAULT_AMOUNT_TO_CHARGE = Settings.default_amount_to_charge_driver
  MIN_TOLL_CREDIT = Settings.min_toll_credit_for_driver
  TOLL_AMOUNT_FOR_DISPATCH = Settings.toll_amount_for_dispatch

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

  has_many :transactions

  validates :first_name, :last_name, :password, :mobile_number, :email, :license_number, :company,
            :license_expiry_date, :license_image, :badge_number, :badge_expiry_date, :ara_image,
            :ara_expiry_date, :insurance_company, :insurance_policy_number, :insurance_expiry_date, presence: true
  validates :mobile_number, :license_number, :badge_number, :email, uniqueness: true
  validate :license_image_size, :ara_image_size

  mount_uploader :license_image, ImageUploader
  mount_uploader :ara_image, ImageUploader


  accepts_nested_attributes_for :address

  before_create :set_merchant_id, :create_payment_profile

  alias_attribute :topic, :merchant_id
  alias_attribute :channel, :merchant_id

  SUPER_ADMIN_ACTIONS.each do |action, status|
    define_method("#{action}!") do
      if action.to_s == "approve"
        PaymentTransactionWorker.perform_async(self) unless self.has_enough_toll_credit?
      end

      self.status = status
      self.save
    end
  end

  def full_name
    [first_name, last_name].join(' ').strip
  end

  def has_enough_toll_credit?
    self.toll_credit >= MIN_TOLL_CREDIT + TOLL_AMOUNT_FOR_DISPATCH
  end

  def deduct_toll_credit!(amount)
    self.toll_credit = self.toll_credit - amount
    self.save
  end

  def charge_customer!(amount=DEFAULT_AMOUNT_TO_CHARGE)
    payment_transaction = Payment.charge_customer_profile(self.customer_profile_id, self.customer_payment_profile_id, amount)

    if payment_transaction[:status] == "success"
      transaction = self.transactions.create(amount: amount,
                      transaction_number: payment_transaction[:transaction_number],
                      status: true
                    )

      self.update_attribute(:toll_credit, self.toll_credit + amount)
      return true
    else
      errors.add(:credit_card, " amount deduction failed.")
      return false
    end
  end

  def update_payment_profile(params)
    payment_profile = Payment.update_customer_payment_profile(self.customer_profile_id, self.customer_payment_profile_id,
      params[:card_number], params[:card_expiry_date], params[:card_code] )

    payment_profile[:status] == "success" ? true : false
  end

  def manage_toll_insufficiency
    MobileNotification.create(
      driver_id: self.id,
      title: Settings.mobile_notification.insufficient_balance.title,
      body: Settings.mobile_notification.insufficient_balance.body,
      data: {
        status: 'insufficient_balance'
      }.to_json
    )
  end

  def visible!
    self.update_attribute(:visible, true)
  end

  def invisible!
    self.update_attribute(:visible, false)
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

  def set_merchant_id
    merchant_id = "driver_#{Time.now.to_i}"
    loop do
      break merchant_id unless Driver.find_by(merchant_id: merchant_id).present?
      merchant_id-=1
    end
    self.merchant_id = merchant_id
  end

  def create_payment_profile
    profile_response = Payment.create_customer_profile(self.merchant_id, self.email)

    if profile_response[:status] == "success"
      self.customer_profile_id = profile_response[:customer_profile_id]

      payment_profile_response = Payment.create_customer_payment_profile(self.customer_profile_id, 
                                  card_number, card_expiry_date, card_code)
      if payment_profile_response[:status] == "success"
        self.customer_payment_profile_id = payment_profile_response[:customer_payment_profile_id]
      else
        errors.add(:credit_card, "information provided is not valid.")
        return false
      end
    else
      errors.add(:credit_card, "information provided is not valid.")
      return false
    end
  end
end