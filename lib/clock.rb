require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

every(1.minute, 'tick') do
  puts 'tick'

  Account.find_each do |account|
    if account.needs_to_pay?
      Delayed::Job.enqueue(PaymentJob.new(account))
    end
  end
end

