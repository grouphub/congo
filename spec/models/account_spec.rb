require 'spec_helper'

describe Account do

  describe '#needs_invoicing?' do

    context 'no invoices were created yet' do

      it 'returns false if account is in demo period' do
        account = Account.create! \
          name: 'Overdue Account',
          billing_start: 29.days.ago,
          billing_day: 29.days.ago.day

        expect(account.needs_invoicing?).to eq(false)
      end

      it 'returns true if account is out of demo period' do
        account = Account.create! \
          name: 'Overdue Account',
          billing_start: 31.days.ago,
          billing_day: 31.days.ago.day

        expect(account.needs_invoicing?).to eq(true)
      end

    end

    context 'invoices have been created' do

      it 'returns false if account is in demo period' do
        account = Account.create! \
          name: 'Overdue Account',
          billing_start: 29.days.ago,
          billing_day: 29.days.ago.day

        invoice = Invoice.create! \
          account_id: account.id,
          membership_id: nil,
          cents: 100,
          plan_name: 'basic'

        expect(account.needs_invoicing?).to eq(false)
      end

      it 'returns false if account is out of demo period and invoice is new' do
        account = Account.create! \
          name: 'Overdue Account',
          billing_start: 2.months.ago,
          billing_day: 2.months.ago.day

        invoice = Invoice.create! \
          account_id: account.id,
          membership_id: nil,
          cents: 100,
          plan_name: 'basic'

        expect(account.needs_invoicing?).to eq(false)
      end

      it 'returns false if account is out of demo period and invoice is old' do
        account = Account.create! \
          name: 'Overdue Account',
          billing_start: 2.months.ago,
          billing_day: 2.months.ago.day

        invoice = Invoice.create! \
          account_id: account.id,
          membership_id: nil,
          cents: 100,
          plan_name: 'basic'

        invoice.update_attributes! \
          created_at: 40.days.ago

        expect(account.needs_invoicing?).to eq(true)
      end

    end

  end

  describe '#unpaid_invoices' do

    it 'returns unpaid invoices' do
      account = Account.create! \
        name: 'Overdue Account'

      unpaid_invoice = Invoice.create! \
        account_id: account.id,
        membership_id: nil,
        cents: 100,
        plan_name: 'basic'

      unpaid_invoice_2 = Invoice.create! \
        account_id: account.id,
        membership_id: nil,
        cents: 100,
        plan_name: 'basic',
        paid: false


      unpaid_invoice_3 = Invoice.create! \
        account_id: account.id,
        membership_id: nil,
        plan_name: 'basic',
        paid: false

      paid_invoice = Invoice.create! \
        account_id: account.id,
        membership_id: nil,
        cents: 100,
        plan_name: 'basic',
        paid: true

      payment = Payment.create!

      paid_invoice = Invoice.create! \
        account_id: account.id,
        membership_id: nil,
        cents: 100,
        plan_name: 'basic',
        payment_id: payment.id

      expect(account.unpaid_invoices.count).to eq 3
    end

  end

  describe '#unpaid_cents' do

    it 'returns unpaid amount in cents' do
      account = Account.create! \
        name: 'Overdue Account'

      unpaid_invoice = Invoice.create! \
        account_id: account.id,
        membership_id: nil,
        cents: 100,
        plan_name: 'basic'

      unpaid_invoice_2 = Invoice.create! \
        account_id: account.id,
        membership_id: nil,
        cents: 100,
        plan_name: 'basic',
        paid: false


      unpaid_invoice_3 = Invoice.create! \
        account_id: account.id,
        membership_id: nil,
        plan_name: 'basic',
        paid: false

      paid_invoice = Invoice.create! \
        account_id: account.id,
        membership_id: nil,
        cents: 100,
        plan_name: 'basic',
        paid: true

      payment = Payment.create!

      paid_invoice = Invoice.create! \
        account_id: account.id,
        membership_id: nil,
        cents: 100,
        plan_name: 'basic',
        payment_id: payment.id

      expect(account.unpaid_cents).to eq(200)
    end

  end

  describe '#enabled_features' do

    it 'returns a feature if it is enabled for all' do
      feature = Feature.create \
        name: 'foo',
        enabled_for_all: true

      account = Account.create

      expect(account.enabled_features).to eq([feature])
    end

    it 'returns a feature if it is enabled for the account' do
      feature = Feature.create \
        name: 'foo',
        account_slugs: %w[first_account]

      account = Account.create \
        name: 'First Account'

      expect(account.enabled_features).to eq([feature])
    end

    it 'does not return a feature if it is not available for an account' do
      feature = Feature.create \
        name: 'foo',
        account_slugs: %w[second_account]

      account = Account.create \
        name: 'First Account'

      expect(account.enabled_features).to eq([])
    end

  end

  describe '#feature_enabled?' do

    it 'returns true if the feature is enabled by account id' do
      feature = Feature.create \
        name: 'foo',
        account_slugs: %w[first_account]

      account = Account.create \
        name: 'First Account'

      expect(account.feature_enabled?('foo')).to eq(true)
    end

    it 'returns true if the feature is enabled for all' do
      feature = Feature.create \
        name: 'foo',
        enabled_for_all: true

      account = Account.create \
        name: 'First Account'

      expect(account.feature_enabled?('foo')).to eq(true)
    end

    it 'returns false if the feature is not enabled' do
      feature = Feature.create \
        name: 'foo',
        account_slugs: %w[second_account]

      account = Account.create \
        name: 'First Account'

      expect(account.feature_enabled?('foo')).to eq(false)
    end

  end

  describe '#nuke!' do

    it 'destroys all account data' do
      account = Account.create! \
        name: 'First Account',
        tagline: 'First account is best account!',
        plan_name: 'premier',
        properties: {
          name: 'First Account',
          tagline: 'First account is best account!',
          plan_name: 'premier',
          tax_id: '123',
          first_name: 'Barry',
          last_name: 'Broker',
          phone: '(555) 555-5555'
        }

      broker_user = User.create! \
        first_name: 'Bob',
        last_name: 'Broker',
        email: 'bob@broker.io',
        password: 'testtest'

      broker_invitation = Invitation.create! \
        description: 'For the broker'

      broker_role = Role.create! \
        user_id: broker_user.id,
        account_id: account.id,
        name: 'broker',
        invitation_id: broker_invitation.id

      broker_invitation.update_attributes! \
        account_id: account.id

      customer_user = User.create! \
        first_name: 'Alice',
        last_name: 'Doe',
        email: 'alice@first-account.com',
        password: 'testtest'

      customer_role = Role.create! \
        user_id: customer_user.id,
        account_id: account.id,
        name: 'customer'

      carrier = Carrier.create! \
        account_id: account.id,
        name: 'Blue Cross',
        properties: {
          name: 'Blue Cross',
          npi: '1467560003',
          trading_partner_id: 'MOCKPAYER',
          service_types: ['health_benefit_plan_coverage'],
          tax_id: '123',
          first_name: 'Brad',
          last_name: 'Bluecross',
          address_1: '123 Somewhere Lane',
          address_2: 'Apt. 123',
          city: 'Somewhereville',
          state: 'CA',
          zip: '94444',
          phone: '444-444-4444'
        }

      carrier_account = CarrierAccount.create! \
        name: 'My Broker Blue Cross',
        carrier_id: carrier.id,
        account_id: account.id,
        properties: {
          name: 'My Broker Blue Cross',
          carrier_slug: 'blue_cross',
          broker_number: '234',
          brokerage_name: 'Example Brokerage',
          tax_id: '345',
          account_type: 'broker'
        }

      benefit_plan = BenefitPlan.create! \
        account_id: account.id,
        carrier_account_id: carrier_account.id,
        is_enabled: true,
        name: 'Best Health Insurance PPO',
        description_html: "<h1>Best Health Insurance PPO</h1>\n<p>An example plan.</p>",
        description_markdown: "# Best Health Insurance PPO\n\nAn example plan.",
        properties: {
          name: 'Best Health Insurance PPO',
          description_html: "<h1>Best Health Insurance PPO</h1>\n<p>An example plan.</p>",
          description_markdown: "# Best Health Insurance PPO\n\nAn example plan."
        }

      account_benefit_plan = AccountBenefitPlan.create! \
        account_id: account.id,
        carrier_id: carrier.id,
        carrier_account_id: carrier_account.id,
        benefit_plan_id: benefit_plan.id,
        properties: {

        }

      benefit_plan_attachment = Attachment.create! \
        account_id: account.id,
        benefit_plan_id: benefit_plan.id,
        title: 'Sample Attachment',
        filename: '123',
        description: 'Just a sample attachment',
        content_type: 'image/png',
        url: 'http://localhost:5001/some_bucket/123'

      group = Group.create! \
        account_id: account.id,
        name: 'My Group',
        is_enabled: true,
        description_html: "<h1>My Group</h1>\n<p>An example group.</p>",
        description_markdown: "# My Group\n\nAn example group.",
        properties: {
          name: 'My Group',
          group_id: '234',
          tax_id: '345',
          description_html: "<h1>My Group</h1>\n<p>An example group.</p>",
          description_markdown: "# My Group\n\nAn example group."
        }

      group_benefit_plan = GroupBenefitPlan.create! \
        account_id: account.id,
        group_id: group.id,
        benefit_plan_id: benefit_plan.id

      group_attachment = Attachment.create! \
        account_id: account.id,
        group_id: group.id,
        title: 'Sample Attachment 2',
        filename: '124',
        description: 'Another sample attachment',
        content_type: 'image/jpg',
        url: 'http://localhost:5001/some_bucket/124'

      token = Token.create! \
        account_id: account.id,
        name: 'Example API Token'

      customer_membership = Membership.create! \
        account_id: account.id,
        group_id: group.id,
        user_id: customer_user.id,
        role_id: customer_role.id,
        email: customer_user.email

      customer_application = Application.create! \
        account_id: account.id,
        benefit_plan_id: benefit_plan.id,
        membership_id: customer_membership.id

      account.nuke!

      expect(Account.where(id: account.id)).to_not be_present
      expect(Invitation.where(id: broker_invitation.id)).to_not be_present
      expect(Role.where(id: broker_role.id)).to_not be_present
      expect(Role.where(id: customer_role.id)).to_not be_present
      expect(CarrierAccount.where(id: carrier_account.id)).to_not be_present
      expect(BenefitPlan.where(id: benefit_plan.id)).to_not be_present
      expect(AccountBenefitPlan.where(id: account_benefit_plan.id)).to_not be_present
      expect(Attachment.where(id: benefit_plan_attachment.id)).to_not be_present
      expect(Group.where(id: group.id)).to_not be_present
      expect(GroupBenefitPlan.where(id: group_benefit_plan.id)).to_not be_present
      expect(Attachment.where(id: group_attachment.id)).to_not be_present
      expect(Token.where(id: token.id)).to_not be_present
      expect(Membership.where(id: customer_membership.id)).to_not be_present
      expect(Application.where(id: customer_application.id)).to_not be_present
      expect(Carrier.where(id: carrier.id)).to_not be_present

      expect(User.where(id: broker_user.id)).to be_present
      expect(User.where(id: customer_user.id)).to be_present
    end

    it 'preserves carriers and benefit plans created by an admin' do
      account = Account.create! \
        name: 'First Account',
        tagline: 'First account is best account!',
        plan_name: 'premier',
        properties: {
          name: 'First Account',
          tagline: 'First account is best account!',
          plan_name: 'premier',
          tax_id: '123',
          first_name: 'Barry',
          last_name: 'Broker',
          phone: '(555) 555-5555'
        }

      carrier = Carrier.create! \
        name: 'Blue Cross',
        properties: {
          name: 'Blue Cross',
          npi: '1467560003',
          trading_partner_id: 'MOCKPAYER',
          service_types: ['health_benefit_plan_coverage'],
          tax_id: '123',
          first_name: 'Brad',
          last_name: 'Bluecross',
          address_1: '123 Somewhere Lane',
          address_2: 'Apt. 123',
          city: 'Somewhereville',
          state: 'CA',
          zip: '94444',
          phone: '444-444-4444'
        }

      carrier_account = CarrierAccount.create! \
        name: 'My Broker Blue Cross',
        carrier_id: carrier.id,
        account_id: account.id,
        properties: {
          name: 'My Broker Blue Cross',
          carrier_slug: 'blue_cross',
          broker_number: '234',
          brokerage_name: 'Example Brokerage',
          tax_id: '345',
          account_type: 'broker'
        }

      benefit_plan = BenefitPlan.create! \
        carrier_id: carrier.id,
        carrier_account_id: carrier_account.id,
        is_enabled: true,
        name: 'Best Health Insurance PPO',
        description_html: "<h1>Best Health Insurance PPO</h1>\n<p>An example plan.</p>",
        description_markdown: "# Best Health Insurance PPO\n\nAn example plan.",
        properties: {
          name: 'Best Health Insurance PPO',
          description_html: "<h1>Best Health Insurance PPO</h1>\n<p>An example plan.</p>",
          description_markdown: "# Best Health Insurance PPO\n\nAn example plan."
        }

      account_benefit_plan = AccountBenefitPlan.create! \
        account_id: account.id,
        carrier_id: carrier.id,
        carrier_account_id: carrier_account.id,
        benefit_plan_id: benefit_plan.id,
        properties: {

        }

      account.nuke!

      expect(CarrierAccount.where(id: carrier_account.id)).to_not be_present
      expect(AccountBenefitPlan.where(id: account_benefit_plan.id)).to_not be_present

      expect(Carrier.where(id: carrier.id)).to be_present
      expect(BenefitPlan.where(id: benefit_plan.id)).to be_present
    end
  end
end
