class PaymentJob
  include Sidekiq::Worker

  def perform(account_id)
    account = Account.find(account_id)

    begin
      data = {
        amount: 0,
        currency: 'usd',
        card: {
          number: '4242424242424242',
          exp_month: 10,
          exp_year: 2015,
          cvc: '314'
        },
        description: 'GroupHub Standard plan charge for admin@example.com'
      }

      key = Rails.application.config.stripe.publishable_key

      Stripe::Charge.create(data, key)

      payment = Payment.create! \
        account_id: account.id,
        cents: 0,
        properties: {}

      Rails.logger.info '===='
      Rails.logger.info 'Paid'
      Rails.logger.info '===='
      Rails.logger.info account.inspect
      Rails.logger.info payment.inspect
    rescue StandardError => e
      Rails.logger.error '====='
      Rails.logger.error 'Error'
      Rails.logger.error '====='
      Rails.logger.error account.inspect
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
    end

  end
end

