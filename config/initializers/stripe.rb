require 'stripe'

Stripe.api_key = Congo2::Application.config.stripe.publishable_key

