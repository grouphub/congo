class PaymentTick < Tick
  queue_name :payment

  def tick
    clock.logger.info 'Tick. Payment is currently disabled.'

    # clock.logger.info 'Tick.'

    # Account.find_each do |account|
    #   if account.needs_to_pay?
    #     PaymentJob.perform_later(account)
    #   end
    # end
  end
end

