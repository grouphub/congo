require 'rails_helper'

describe 'Authentication', js: true do
  def admin_signin!
    account = Account.create \
      name: 'Admin',
      tagline: 'GroupHub administrative account',
      plan_name: 'admin'

    user = User.create \
      first_name: 'GroupHub',
      last_name: 'Admin',
      email: 'admin@grouphub.io',
      password: 'testtest'

    Role.create \
      user_id: user.id,
      account_id: account.id,
      name: 'admin'

    visit '/'

    all('a', text: 'Sign In').first.click

    expect(page).to have_content('Email')

    fill_in 'Email', with: 'admin@grouphub.io'
    fill_in 'Password', with: 'testtest'

    all('button', text: 'Sign In').first.click

    expect(page).to have_content('Administrator Dashboard')
  end

  def admin_signout!
    all('a', text: 'GroupHub').first.click

    expect(page).to have_content('Sign Out')

    all('a', text: 'Sign Out').first.click

    expect(page).to have_content('You have signed out.')
    expect(page).to have_content('The next generation')
  end

  describe 'as an administrator' do
    it 'allows an administrator to sign in and out' do
      admin_signin!
      admin_signout!
    end
  end

  describe 'as a broker' do
    it 'allows a broker to sign in and out'

    it 'allows a broker to sign up' do
      page.driver.browser.manage.window.resize_to(1024, 768)

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

      current_user = page.evaluate_script('window.congo.currentUser')

      expect(current_user['first_name']).to eq('Barry')
      expect(current_user['last_name']).to eq('Broker')
      expect(current_user['email']).to eq('barry@broker.com')
      expect(current_user['invitation_id']).to be_nil
      expect(current_user['is_admin']).to be_falsey
      expect(current_user['accounts'].length).to eq(1)
    end

    it 'allows a broker to sign up with an invitation code' do
      page.driver.browser.manage.window.resize_to(1024, 768)

      admin_signin!

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

        expect(invitation_code).to match(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/)
      end

      admin_signout!

      visit '/'

      all('a', text: 'Sign Up').first.click

      fill_in 'First Name', with: 'Barry'
      fill_in 'Last Name', with: 'Broker'
      fill_in 'Email', with: 'barry@broker.com'
      fill_in 'Password', with: 'barry'
      fill_in 'Confirm Password', with: 'barry'

      all('button', text: 'Add User').first.click

      page.execute_script "window.scrollBy(0, 10000)"

      fill_in 'Invitation Code', with: invitation_code

      all('input[type=submit]').first.click

      page.execute_script "window.scrollBy(0, -10000)"

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

      current_user = page.evaluate_script('window.congo.currentUser')

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

  describe 'as a customer' do
    it 'allows a customer to sign in and out'
  end
end

