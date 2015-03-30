describe Application do
  describe '#to_pokitdok' do
    it 'converts an application into a PokitDok-friendly format' do
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
        name: 'Blue Shield',
        properties: {
          name: 'Blue Shield',
          npi: '1530731902',
          trading_partner_id: 'MOCKPAYER',
          service_types: ['health_benefit_plan_coverage'],
          tax_id: '234',
          first_name: 'Billy',
          last_name: 'Blueshield',
          address_1: '123 Somewhere Lane',
          address_2: 'Apt. 123',
          city: 'Somewhereville',
          state: 'CA',
          zip: '94444',
          phone: '444-444-4444'
        }

      carrier_account = CarrierAccount.create! \
        name: 'Admin Blue Shield',
        carrier_id: carrier.id,
        properties: {
          name: 'Admin Blue Shield',
          carrier_slug: 'blue_shield',
          broker_number: '123',
          brokerage_name: 'Example Brokerage',
          tax_id: '234',
          account_type: 'broker'
        }

      benefit_plan = BenefitPlan.create! \
        carrier_account_id: carrier_account.id,
        is_enabled: true,
        name: 'Admin Health Insurance PPO',
        description_html: "<h1>Admin Health Insurance PPO</h1>\n<p>An example plan.</p>",
        description_markdown: "# Admin Health Insurance PPO\n\nAn example plan.",
        properties: {
          name: 'Admin Health Insurance PPO',
          description_html: "<h1>Admin Health Insurance PPO</h1>\n<p>An example plan.</p>",
          description_markdown: "# Admin Health Insurance PPO\n\nAn example plan.",
          plan_type: 'foo',
          exchange_plan: 'bar',
          small_group: 'baz',
          group_id: '234'
        }

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

      alice = User.create! \
        first_name: 'Alice',
        last_name: 'Doe',
        email: 'alice@first-account.com',
        password: 'testtest'

      Role.create! \
        user_id: alice.id,
        account_id: account.id,
        name: 'customer'

      membership = Membership.create! \
        group_id: group.id,
        user_id: alice.id,
        role_id: alice.roles.first.id,
        email: alice.email

      properties = JSON.parse(File.read("#{Rails.root}/spec/data/application.json"))

      application = Application.create! \
        account_id: nil,
        benefit_plan_id: benefit_plan.id,
        membership_id: membership.id,
        reference_number: '4aueb8vr2z5es3gpu78alq3yt',
        properties: properties

      application_pokitdok = JSON.parse(File.read("#{Rails.root}/spec/data/application-pokitdok.json"))

      expect(application.to_pokitdok).to eq(application_pokitdok)
    end
  end
end

