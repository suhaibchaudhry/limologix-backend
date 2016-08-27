class PaymentTransactionWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'payment_transactions', retry: false

  def perform(driver_id=nil)
    driver = Driver.find_by(id: driver_id)

    if driver.present?
      if driver.charge_customer!
        notification_data = { status: 'account_approved'}.reverse_merge!(
          TransactionSerializer.new(driver.transactions.last).serializable_hash
        )

        MobileNotification.create(
          driver_id: driver.id,
          title: Settings.mobile_notification.account_approved.title,
          body: Settings.mobile_notification.account_approved.body,
          data: notification_data.to_json
        )
      else
        MobileNotification.create(
          driver_id: driver.id,
          title: Settings.mobile_notification.payment_failure.title,
          body: Settings.mobile_notification.payment_failure.body,
          data: {}
        )
      end
    end

  end
end