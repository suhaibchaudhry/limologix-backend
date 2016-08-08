class PaymentTransactionWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'payment_transactions', retry: false

  def perform(driver_id=nil)
    driver = Driver.find_by(id: driver_id)
    if driver.present?
      if driver.charge_customer!
        MobileNotification.create(driver_id: driver.id, 
          title: Settings.mobile_notification.payment_success.title, body: Settings.mobile_notification.payment_success.body,
          data: TransactionSerializer.new(driver.transactions.last).to_json)
      else
        MobileNotification.create(driver_id: driver.id,
          title: Settings.mobile_notification.payment_failure.title, body: Settings.payment_failure.payment_success.body, data: nil)
      end
    end
  end
end