class InvoiceTick < Tick
  queue_name :invoice

  def tick
    clock.logger.info 'Tick.'

    Account.find_each do |account|
      InvoiceJob.perform_later(account)
    end
  end
end

