require 'rails_helper'

describe 'Authentication', js: true do
  describe 'as an administrator' do
    it 'allows an administrator to sign in and out' do
      create_admin
      signin_admin
      signout_admin
    end
  end

  describe 'as a broker' do
    it 'allows a broker to sign in and out' do
      create_broker
      signin_broker
      signout_broker
    end

    it 'allows a broker to sign up' do
      visit '/'

      all('a', text: 'Sign Up').first.click

      fill_in 'First Name', with: 'Barry'
      fill_in 'Last Name', with: 'Broker'
      fill_in 'Email', with: 'barry@broker.com'
      fill_in 'Password', with: 'barry'
      fill_in 'Confirm Password', with: 'barry'

      all('button', text: 'Add User').first.click

      expect(page).to have_content('Pick a plan')

      within 'ul.plan.featured' do
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
      fill_in 'Account Contact First Name', with: 'Barry'
      fill_in 'Account Contact Last Name', with: 'Barry Broker'
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
    end

    it 'allows a broker to sign up with an invitation code' do
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

        expect(invitation_code).to be_a_uuid
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
      fill_in 'Account Contact First Name', with: 'Barry'
      fill_in 'Account Contact Last Name', with: 'Barry Broker'
      fill_in 'Phone Number', with: '(555) 555-5555'

      all('input[type=submit]').first.click

      expect(page).to have_content('Welcome, Barry Broker!')
      expect(page).to have_content('Broker Dashboard: First Account')

      current_user = current_user_data
      expect(current_user['first_name']).to eq('Barry')
      expect(current_user['last_name']).to eq('Broker')
      expect(current_user['email']).to eq('barry@broker.com')
      expect(current_user['invitation_id']).not_to be_nil
      expect(current_user['is_admin']).to be_falsey
      expect(current_user['accounts'].length).to eq(1)
    end
  end

  describe 'as a group admin' do
    it 'allows a group admin to sign in and out'
  end

  # describe 'as a customer' do
  #   it 'allows a customer to sign in and out' do
  #     create_customer
  #     signin_customer
  #     signout_customer
  #   end

  #   it 'allows a customer to be invited to an account' do
  #     create_broker

  #     account = Account.first
  #     create_group_for(account)

  #     signin_broker

  #     all('a', text: 'Manage Groups').first.click

  #     expect(page).to have_content('Select benefits options')

  #     all('a', text: 'My Group').first.click

  #     expect(page).to have_content('Benefit Plans')

  #     scroll_by(500)
  #   end
  # end
end

