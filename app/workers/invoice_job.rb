class InvoiceJob < ActiveJob::Base
  queue_as :default

  if ENV['AWS_REGION']
    rescue_from ActiveJob::DeserializationError do |e|
      Shoryuken.logger.error e
      Shoryuken.logger.error e.backtrace.join("\n")
    end
  end

  def perform(account_id)
    account = Account.find(account_id)

    unless account.needs_invoicing?
      Rails.logger.info("Account with ID #{account_id} did not need invoicing.")
      return
    end

    plan_name = account.plan_name
    plan_cost = Invoice::PLAN_COSTS[plan_name.to_sym]

    account.memberships.each do |membership|
      next unless membership.invoiceable?

      invoice = Invoice.create! \
        account_id: account.id,
        membership_id: membership.id,
        cents: plan_cost,
        plan_name: plan_name,
        properties: {}

      Rails.logger.info '========'
      Rails.logger.info 'Invoiced'
      Rails.logger.info '========'
      Rails.logger.info account.inspect
      Rails.logger.info invoice.inspect
    end
  end
end

