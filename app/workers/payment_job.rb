require 'stripe'

class PaymentJob
  def initialize(account)
    @account = account
  end

  def perform
    begin
      Stripe::Charge.create \
        {
          amount: 0,
          currency: 'usd',
          card: {
            number: '4242424242424242',
            exp_month: 10,
            exp_year: 2015,
            cvc: '314'
          },
          description: 'GroupHub Standard plan charge for admin@example.com'
        },
        Congo2::Application.config.stripe.publishable_key

      payment = Payment.create! \
        account_id: @account.id,
        cents: 0,
        properties: {}

      pp ['pay', @account, payment]
    rescue StandardError => e
      pp ['error', @account, e]
    end

  end
end

