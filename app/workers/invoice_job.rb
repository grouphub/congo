class InvoiceJob < ActiveJob::Base
  queue_as :default

  if ENV['AWS_REGION']
    rescue_from ActiveJob::DeserializationError do |e|
      Shoryuken.logger.error ex
      Shoryuken.logger.error ex.backtrace.join("\n")
    end
  end

  def perform(account_id)
    redlock = Redlock::Client.new([Rails.application.config.redis.url])

    # Lock will expire in five minutes if not relinquished.
    redlock.lock("account_#{account_id}_invoice", 5 * 60 * 1000) do |lock_acquired|
      unless lock_acquired
        Rails.logger.info("Another worker is attempting to handle invoice for account with ID #{account_id}.")
        return
      end

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
end

