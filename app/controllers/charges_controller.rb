class ChargesController < ApplicationController
def new
end

def create

Stripe.api_key = "sk_test_3u36ymxidCQDcnaojEM8FINu"


  token = params[:stripeToken]
  # Amount in cents
  @amount = 4000000

  customer = Stripe::Customer.create(
    :email => params[:stripeEmail],
    :source  => token
  )

  charge = Stripe::Charge.create(
    :customer    => customer.id,
    :amount      => @amount,
    :description => 'Rails Stripe customer',
    :currency    => 'usd'
  )

rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to new_charge_path
end
end
