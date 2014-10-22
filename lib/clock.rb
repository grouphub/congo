require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

every(1.minute, 'tick') do
  puts 'tick'

  Account.find_each do |account|
    if account.needs_to_pay?
      Payment.create! \
        account_id: account.id,
        cents: 0,
        properties: {}

      pp ['pay', account, last_payment]
    end
  end
end

