class Payment
  include AuthorizeNet::API

  LOGIN_ID = Rails.application.secrets.authorize_net['login_id']
  TRANSACTION_KEY= Rails.application.secrets.authorize_net['transaction_key']
  GATEWAY = Rails.env == 'production' ? :live : :sandbox

  def self.create_transaction_object
    Transaction.new(LOGIN_ID, TRANSACTION_KEY, :gateway => GATEWAY)
  end

  def self.create_customer_profile(merchant_id, email)
    begin
      transaction = create_transaction_object
      request = CreateCustomerProfileRequest.new
      request.profile = CustomerProfileType.new(merchant_id, 'Limo-logix', email, nil, nil)

      response = transaction.create_customer_profile(request)

      if response.messages.resultCode == MessageTypeEnum::Ok
        { status: "success", customer_profile_id: response.customerProfileId }
      else
        raise response.messages.messages[0].text
      end
    rescue Exception => e
      { status: "error", message: e.message }
    end
  end

  def self.get_customer_profile(customer_profile_id)
    begin
      transaction = create_transaction_object
      request = GetCustomerProfileRequest.new
      request.customerProfileId = customer_profile_id

      response = transaction.get_customer_profile(request)


      if response.messages.resultCode == MessageTypeEnum::Ok
        raise "Customer is having more than one payment profile" if (response.profile.paymentProfiles.count > 1)
        payment_profile = response.profile.paymentProfiles.first
        payment_profile_id = payment_profile.present? ? payment_profile.customerPaymentProfileId : nil

        { status: "success", customer_payment_profile_id: payment_profile.customerPaymentProfileId,
          merchant_id:  response.profile.merchantCustomerId, email: response.profile.email }
      else
        raise response.messages.messages[0].text
      end
    rescue Exception => e
      { status: "error", message: e.message }
    end
  end

  def self.update_customer_profile(customer_profile_id, merchant_id, email)
    begin
      transaction = create_transaction_object

      request = UpdateCustomerProfileRequest.new
      request.profile = CustomerProfileExType.new

      request.profile.customerProfileId = customer_profile_id
      request.profile.merchantCustomerId = merchant_id
      request.profile.email = email
      response = transaction.update_customer_profile(request)


      if response.messages.resultCode == MessageTypeEnum::Ok
        { status: "success", message: "Customer profile updated successfully." }
      else
        raise response.messages.messages[0].text
      end
    rescue Exception => e
      { status: "error", message: e.message }
    end
  end

  def self.create_customer_payment_profile(customer_profile_id, card_number, card_expiry_date, card_code )
    begin
      transaction = create_transaction_object
      request = CreateCustomerPaymentProfileRequest.new

      payment = PaymentType.new(CreditCardType.new(card_number, card_expiry_date, card_code))
      profile = CustomerPaymentProfileType.new(nil,nil,payment,nil,nil)

      request.paymentProfile = profile
      request.customerProfileId = customer_profile_id
      response = transaction.create_customer_payment_profile(request)


      if response.messages.resultCode == MessageTypeEnum::Ok
        { status: "success", customer_payment_profile_id: response.customerPaymentProfileId }
      else
        raise response.messages.messages[0].text
      end
    rescue Exception => e
      { status: "error", message: e.message }
    end
  end

  def self.get_customer_payment_profile(customer_profile_id, customer_payment_profile_id )
     begin
      transaction = create_transaction_object

      request = GetCustomerPaymentProfileRequest.new
      request.customerProfileId = customer_profile_id
      request.customerPaymentProfileId = customer_payment_profile_id
      response = transaction.get_customer_payment_profile(request)

      if response.messages.resultCode == MessageTypeEnum::Ok
        credit_card = response.paymentProfile.payment.creditCard

        { status: "success", customer_payment_profile_id: response.paymentProfile.customerPaymentProfileId,
        card_number: credit_card.cardNumber, card_type: credit_card.cardType }
      else
        raise response.messages.messages[0].text
      end
    rescue Exception => e
      { status: "error", message: e.message }
    end
  end

  def self.update_customer_payment_profile(customer_profile_id, customer_payment_profile_id, card_number, card_expiry_date, card_code )
    begin
      transaction = create_transaction_object

      request = UpdateCustomerPaymentProfileRequest.new

      payment = PaymentType.new(CreditCardType.new(card_number, card_expiry_date, card_code))
      profile = CustomerPaymentProfileExType.new(nil,nil,payment,nil,nil)

      request.paymentProfile = profile
      request.customerProfileId = customer_profile_id
      profile.customerPaymentProfileId = customer_payment_profile_id

      response = transaction.update_customer_payment_profile(request)

      if response.messages.resultCode == MessageTypeEnum::Ok
        { status: "success", message: "Customer payment profile updated successfully." }
      else
        raise response.messages.messages[0].text
      end
    rescue Exception => e
      { status: "error", message: e.message }
    end
  end

  def self.charge_customer_profile(customer_profile_id, customer_payment_profile_id, amount)
    begin
      transaction = create_transaction_object

      request = CreateTransactionRequest.new

      request.transactionRequest = TransactionRequestType.new()
      request.transactionRequest.amount = amount
      request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction
      request.transactionRequest.profile = CustomerProfilePaymentType.new
      request.transactionRequest.profile.customerProfileId = customer_profile_id
      request.transactionRequest.profile.paymentProfile = PaymentProfile.new(customer_payment_profile_id)

      response = transaction.create_transaction(request)

      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactionResponse != nil
          { status: "success", transaction_number: response.transactionResponse.transId }
        end
      else
        raise response.messages.messages[0].text
      end
    rescue Exception => e
      { status: "error", message: e.message }
    end
  end
end