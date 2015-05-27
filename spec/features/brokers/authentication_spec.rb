require 'rails_helper'

describe 'As a broker', js: true do

  describe 'Authentication' do

    it 'allows them to sign in and out' do
      create_broker
      signin_broker
      signout_broker
    end

    %w[basic standard premier].each do |plan_name|
      it "allows them to sign up for a \"#{plan_name}\" plan" do
        visit '/'

        all('a', text: 'Sign Up').first.click

        fill_in 'First Name', with: 'Barry'
        fill_in 'Last Name', with: 'Broker'
        fill_in 'Email', with: 'barry@broker.com'
        fill_in 'Password', with: 'barry'
        fill_in 'Confirm Password', with: 'barry'

        all('button', text: 'Add User').first.click

        expect(page).to have_content('Pick a plan')

        within "ul.plan.#{plan_name}" do
          all('a', text: 'Sign Up').first.click
        end

        expect(page).to have_content('Billing Information')

        fill_in 'Card Number', with: '4444-4444-4444-4444'
        fill_in 'Expiration Month', with: '04'
        fill_in 'Expiration Year', with: '04'
        fill_in 'CVC Code', with: '444'

        all('button', text: 'Save').first.click

        expect(page).to have_content('Create Account')

        fill_in 'Name', with: 'First Account'
        fill_in 'Company Tagline', with: '#1 Account'
        fill_in 'Tax ID', with: '1234'
        fill_in 'First Name', with: 'Barry'
        fill_in 'Last Name', with: 'Barry Broker'
        fill_in 'Phone Number', with: '(555) 555-5555'

        all('input[type=submit]').first.click

        expect(page).to have_content('Welcome, Barry Broker!')
        expect(page).to have_content('Broker Dashboard: First Account')

        current_user = current_user_data
        expect(current_user['first_name']).to eq('Barry')
        expect(current_user['last_name']).to eq('Broker')
        expect(current_user['email']).to eq('barry@broker.com')
        expect(current_user['invitation_id']).to be_nil
        expect(current_user['is_admin']).to be_falsey
        expect(current_user['accounts'].length).to eq(1)

        current_account = current_user['accounts'].first
        expect(current_account['plan_name']).to eq(plan_name)
      end
    end

    it 'allows them to sign up with an invitation code' do
      create_admin
      signin_admin

      all('a', text: 'Manage Invitations').first.click

      expect(page).to have_content('Invitations')
      expect(page).to have_content('New Invitation')

      fill_in 'Description', with: 'First Invitation'

      all('input[type=submit]').first.click

      invitation_code = nil
      within 'table.invitations tbody' do
        tds = all('td')
        invitation_code = tds[0].text.strip

        expect(tds.length).to eq(4)
        expect(tds[1].text).to eq('First Invitation')

        expect(invitation_code).to be_a_thirty_six
      end

      signout_admin

      visit '/'

      all('a', text: 'Sign Up').first.click

      fill_in 'First Name', with: 'Barry'
      fill_in 'Last Name', with: 'Broker'
      fill_in 'Email', with: 'barry@broker.com'
      fill_in 'Password', with: 'barry'
      fill_in 'Confirm Password', with: 'barry'

      all('button', text: 'Add User').first.click

      scroll_to_bottom

      fill_in 'Invitation Code', with: invitation_code

      all('input[type=submit]').first.click

      expect(page).to have_content('Create Account')

      fill_in 'Name', with: 'First Account'
      fill_in 'Company Tagline', with: '#1 Account'
      fill_in 'Tax ID', with: '1234'
      fill_in 'First Name', with: 'Barry'
      fill_in 'Last Name', with: 'Barry Broker'
      fill_in 'Phone Number', with: '(555) 555-5555'

      all('input[type=submit]').first.click

      expect(page).to have_content('Welcome, Barry Broker!')
      expect(page).to have_content('Broker Dashboard: First Account')

      current_user = current_user_data
      expect(current_user['first_name']).to eq('Barry')
      expect(current_user['last_name']).to eq('Broker')
      expect(current_user['email']).to eq('barry@broker.com')
      expect(current_user['is_admin']).to be_falsey
      expect(current_user['accounts'].length).to eq(1)

      account_data = current_user['accounts'].first
      user = User.find(current_user['id'])
      role = Role.where(name: 'broker').first
      account = role.account
      invitation = role.invitation
      expect(invitation.account_id).to eq(account.id)
      expect(role.invitation_id).to eq(invitation.id)
      expect(account_data['role']['invitation_id']).to eq(invitation.id)
    end

    it 'prevents them from creating a new account with an existing email address'
    it 'allows them to create a second broker account'

  end

  describe 'Account Settings' do

    it 'allows a broker to edit their account' do
      create_broker

      account = Account.find_by_name('First Account')
      account_properties = account.properties
      account_properties['tax_id'] = '123'
      account_properties['first_name'] = 'Felice'
      account_properties['last_name'] = 'Felton'
      account_properties['phone'] = '555-555-5555'
      account_properties['card_number'] = '1111222233334444'
      account_properties['month'] = '11'
      account_properties['year'] = '2016'
      account_properties['cvc'] = '123'
      account.update_attributes!(properties: account_properties)

      signin_broker

      all('a', text: 'Account Settings').first.click

      within 'main' do
        expect(page).to have_content('Account Settings')

        selected_radio = all('input[type="radio"]').find { |radio| radio.checked? }
        expect(selected_radio.value).to eq('basic')

        values = all('input[type="text"]').map(&:value)
        expect(values).to eq(['First Account', '#1 Account', '123', 'Felice', 'Felton', '555-555-5555', '1111222233334444', '11', '2016'])

        password_values = all('input[type="password"]').map(&:value)
        expect(password_values.length).to eq(1)

        cvc = password_values.first
        expect(cvc).to eq('123')

        fill_in 'Name', with: 'Second Account'
        fill_in 'Tagline', with: '#2 Account'
        fill_in 'Tax ID', with: '234'
        fill_in 'First Name', with: 'Barry'
        fill_in 'Last Name', with: 'Belton'
        fill_in 'Phone Number', with: '444-444-4444'
        fill_in 'Card Number', with: '2222333344445555'
        fill_in 'Expiration Month', with: '12'
        fill_in 'Expiration Year', with: '2017'

        # Not capitalized because it needs to match the name instead of the
        # placeholder.
        fill_in 'cvc', with: '234'

        choose 'Premier'

        all('input[type="submit"]').first.click

        expect(page).to have_content('Account Settings')
      end

      expect(page).to have_content('Successfully updated account!')
      expect(page).to have_content('Broker Dashboard: Second Account')

      expect(page.evaluate_script('window.location.pathname')).to \
        eq('/accounts/second_account/broker')

      accounts = page.evaluate_script('congo.currentUser.accounts')
      expect(accounts.length).to eq(1)

      account = accounts.first
      account_properties = JSON.parse(account['properties_data'])
      expect(account_properties['name']).to eq('Second Account')
      expect(account_properties['tagline']).to eq('#2 Account')
      expect(account_properties['plan_name']).to eq('premier')
      expect(account_properties['tax_id']).to eq('234')
      expect(account_properties['first_name']).to eq('Barry')
      expect(account_properties['last_name']).to eq('Belton')
      expect(account_properties['phone']).to eq('444-444-4444')
      expect(account_properties['month']).to eq('12')
      expect(account_properties['year']).to eq('2017')
      expect(account_properties['cvc']).to eq('234')

      account = Account.find_by_name('Second Account')
      account_properties = account.properties
      expect(account.name).to eq('Second Account')
      expect(account.tagline).to eq('#2 Account')
      expect(account.plan_name).to eq('premier')
      expect(account_properties['name']).to eq('Second Account')
      expect(account_properties['tagline']).to eq('#2 Account')
      expect(account_properties['plan_name']).to eq('premier')
      expect(account_properties['tax_id']).to eq('234')
      expect(account_properties['first_name']).to eq('Barry')
      expect(account_properties['last_name']).to eq('Belton')
      expect(account_properties['phone']).to eq('444-444-4444')
      expect(account_properties['month']).to eq('12')
      expect(account_properties['year']).to eq('2017')
      expect(account_properties['cvc']).to eq('234')
    end

  end

  describe 'API Tokens' do

    it 'allows a broker to see a list of API tokens' do
      Feature.create! \
        name: 'api_tokens',
        account_slugs: %w[first_account]

      create_broker
      signin_broker

      account = Account.find_by_name('First Account')

      Token.create! \
        account_id: account.id,
        name: "Token #1"

      Token.create! \
        account_id: account.id,
        name: "Token #2"

      all('a', text: 'Manage API Tokens').first.click

      within 'table.tokens' do
        tds = all('td')

        expect(tds.length).to eq(6)

        name_1 = tds[0]
        unique_id_1 = tds[1]
        name_2 = tds[3]
        unique_id_2 = tds[4]

        expect(name_1).to have_content('Token #1')
        expect(unique_id_1.text).to be_a_thirty_six
        expect(name_2).to have_content('Token #2')
        expect(unique_id_2.text).to be_a_thirty_six
      end
    end

    it 'allows a broker to create a new API token' do
      Feature.create! \
        name: 'api_tokens',
        account_slugs: %w[first_account]

      create_broker
      signin_broker

      all('a', text: 'Manage API Tokens').first.click

      fill_in 'Name', with: 'For Enrollment'

      all('input[type=submit]').first.click

      expect(page).to have_content('For Enrollment')

      within 'table.tokens' do
        tds = all('td')

        expect(tds.length).to eq(3)

        name = tds[0]
        unique_id = tds[1]

        expect(name).to have_content('For Enrollment')
        expect(unique_id.text).to be_a_thirty_six
      end
    end

    it 'allows a broker to remove an existing API token' do
      # Should not need this. This is to fix test wobbles. Token from previous
      # test is sometimes sticking around.
      Token.destroy_all

      Feature.create! \
        name: 'api_tokens',
        account_slugs: %w[first_account]

      create_broker

      account = Account.find_by_name('First Account')

      Token.create! \
        account_id: account.id,
        name: "Token #1"

      signin_broker

      all('a', text: 'Manage API Tokens').first.click

      within 'table.tokens' do
        expect(page).to have_content('Token #1')

        all('a', text: 'Delete').first.click

        wait_for('AJAX to finish') do
          !page.text.match(/Token \#1/)
        end

        expect(page).to have_no_content('Token #1')
      end
    end

  end

  describe 'Benefit Plans' do

    # TODO: Make sure to test descriptions
    it 'allows a broker to create a benefit plan'

    it 'allows a broker to list benefit plans'
    it 'allows a broker to edit a benefit plan'
    it 'allows a broker to delete a benefit plan'

  end

  describe 'Groups' do

    # TODO: Make sure to test descriptions
    it 'allows a broker to create a group'

    it 'allows a broker to list groups'
    it 'allows a broker to edit a group'
    it 'allows a broker to delete a group'

  end

end

