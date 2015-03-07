require 'rails_helper'

describe 'Authentication', js: true do

  describe 'as a customer' do

    it 'allows a customer to sign in and out' do
      create_customer
      signin_customer
      signout_customer
    end

    it 'allows a customer to be invited to an account' do
      create_broker

      account = Account.first
      create_group_for(account)

      signin_broker

      all('a', text: 'Manage Groups').first.click

      expect(page).to have_content('Select benefits options')

      all('a', text: 'My Group').first.click

      expect(page).to have_content('Benefit Plans')

      within 'form.invite-member' do
        fill_in 'Invite a new member', with: 'alice@first-account.com'
        all('input[type=submit][value="Invite a Member"]').first.click
      end

      expect(ActionMailer::Base.deliveries).to be_empty

      all('a', text: 'Send Invitation').first.click

      wait_for('email to be delivered') do
        ActionMailer::Base.deliveries.length == 1
      end

      email = ActionMailer::Base.deliveries.last
      email_body = email.body.to_s
      email_html = Nokogiri::HTML(email_body)
      activation_link = email_html.css('a:contains("Activate your account")')
      activation_url = activation_link.attr('href').value

      visit activation_url

      expect(page).to have_content('Member Activation')

      fill_in 'First Name', with: 'Alice'
      fill_in 'Last Name', with: 'Foo'
      fill_in 'Email', with: 'alice@first-account.com'
      fill_in 'Password', with: 'testtest'
      fill_in 'Confirm Password', with: 'testtest'

      all('button', text: 'Activate').first.click

      # Welcome flash should be present
      expect(page).to have_content('Welcome, Alice Foo!')

      # Dashboard heading should be present
      expect(page).to have_content('Welcome, Alice!')
    end

    it 'allows an existing user to be invited to an account as a customer' do
      create_broker

      account = Account.first
      create_group_for(account)

      signin_broker

      all('a', text: 'Manage Groups').first.click

      expect(page).to have_content('Select benefits options')

      all('a', text: 'My Group').first.click

      expect(page).to have_content('Benefit Plans')

      within 'form.invite-member' do
        fill_in 'Invite a new member', with: 'barry@broker.com'
        all('input[type=submit][value="Invite a Member"]').first.click
      end

      expect(ActionMailer::Base.deliveries).to be_empty

      all('a', text: 'Send Invitation').first.click

      wait_for('email to be delivered') do
        ActionMailer::Base.deliveries.length == 1
      end

      email = ActionMailer::Base.deliveries.last
      email_body = email.body.to_s
      email_html = Nokogiri::HTML(email_body)
      activation_link = email_html.css('a:contains("Activate your account")')
      activation_url = activation_link.attr('href').value

      visit activation_url

      expect(page).to have_content('Member Activation')

      all('a', text: 'Sign In').first.click

      expect(page).to have_content('Sign In')

      fill_in 'Email', with: 'barry@broker.com'
      fill_in 'Password', with: 'barry'

      all('button', text: 'Sign In').first.click

      # TODO: Should have a sign in flash

      # Barry is already a broker, so it goes to his broker page
      expect(page).to have_content('Broker Dashboard: First Account')

      all('a', text: 'Barry').first.click

      # TODO: Make sure that customer account appears in list
    end

    it 'prevents a customer from creating a new account with an existing email address'

  end

end

