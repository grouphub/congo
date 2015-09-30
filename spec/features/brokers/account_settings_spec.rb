require 'rails_helper'

feature 'Account Settings', :js do
  let(:broker)  { create(:user, :broker) }
  let!(:account) { broker.roles.first.account }

  scenario 'allows a broker to edit their account' do
    properties = {
      'name'        => 'First Account',
      'tagline'     => '#1 Account',
      'plan_name'   => 'basic',
      'tax_id'      => '123',
      'first_name'  => 'Felice',
      'last_name'   => 'Felton',
      'phone'       => '555-555-5555',
      'card_number' => '1111222233334444',
      'month'       => '11',
      'year'        => '2016',
      'cvc'         => '123'
    }

    account.update(properties: properties)

    sign_in broker

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
