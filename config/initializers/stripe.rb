require 'stripe'

#Stripe.api_key = Congo2::Application.config.stripe.publishable_key

Rails.configuration.stripe = {
#  :publishable_key => ENV['STRIPE_PUBLISHABLE_KEY'],
  :publishable_key => Congo2::Application.config.stripe.publishable_key,
#  :secret_key      => ENV['STRIPE_SECRET_KEY']
  :secret_key => Congo2::Application.config.stripe.secret_key
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
