require 'spec_helper'

describe InvoiceJob do

  include ActiveJob::TestHelper

  context 'account needs invoicing' do

    it 'generates invoice records' do
      account = Account.create! \
        name: 'Overdue Account',
        plan_name: 'basic',
        billing_start: 29.days.ago,
        billing_day: 29.days.ago.day

      user = User.create! \
        email: 'foo@bar.com'

      membership = Membership.create! \
        account_id: account.id,
        user_id: user.id,
        created_at: 3.days.ago

      InvoiceJob.perform_now(account.id)

      invoices = Invoice.all

      pp invoices
    end

  end

  context 'account does not need invoicing' do

    it 'does not generate invoice records' do
      account = Account.create! \
        name: 'Overdue Account',
        plan_name: 'basic',
        billing_start: 31.days.ago,
        billing_day: 31.days.ago.day

      user = User.create! \
        email: 'foo@bar.com'

      membership = Membership.create! \
        account_id: account.id,
        user_id: user.id,
        created_at: 3.days.ago

      InvoiceJob.perform_now(account.id)

      invoices = Invoice.all

      pp invoices
    end

  end

end

