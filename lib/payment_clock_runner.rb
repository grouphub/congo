# Run like: `bundle exec clockwork lib/payment_clock_runner.rb`

require "#{File.dirname(__FILE__)}/payment_clock"

PaymentClock.new(*ARGV).start

