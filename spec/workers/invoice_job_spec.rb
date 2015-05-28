require 'spec_helper'

describe InvoiceJob do

  include ActiveJob::TestHelper

  context 'account does not need invoicing' do

    it 'does not generate invoice records' do
      account = Account.create! \
        name: 'Overdue Account',
        plan_name: 'basic',
        billing_start: 29.days.ago,
        billing_day: 29.days.ago.day

      user = User.create! \
        email: 'foo@bar.com'

      role = Role.create! \
        name: 'employee'

      membership = Membership.create! \
        account_id: account.id,
        user_id: user.id,
        role_id: role.id,
        created_at: 3.days.ago

      InvoiceJob.perform_now(account.id)

      invoices = Invoice.all

      expect(invoices).to be_empty
    end

  end

  context 'account needs invoicing' do

    it 'generates invoice records' do
      account = Account.create! \
        name: 'Overdue Account',
        plan_name: 'basic',
        billing_start: 31.days.ago,
        billing_day: 31.days.ago.day

      user = User.create! \
        email: 'foo@bar.com'

      role = Role.create! \
        name: 'employee'

      membership = Membership.create! \
        account_id: account.id,
        user_id: user.id,
        role_id: role.id,
        created_at: 3.days.ago

      InvoiceJob.perform_now(account.id)

      invoices = Invoice.all

      expect(invoices.length).to eq(1)

      invoice = invoices.first

      expect(invoice.account_id).to eq(account.id)
      expect(invoice.membership_id).to eq(membership.id)
      expect(invoice.cents).to eq(100)
      expect(invoice.plan_name).to eq('basic')
    end

  end

end

