require 'rails_helper'

feature 'Broker authentication', :js do
  let(:broker) { create(:user, :broker) }

  scenario 'allows them to sign in and out' do
    sign_in broker
    sign_out broker
  end

  scenario "allows them to sign up for a basic plan" do
    visit '/'

    all('a', text: 'Sign Up').first.click

    fill_in 'First Name', with: 'Barry'
    fill_in 'Last Name', with: 'Broker'
    fill_in 'Email', with: 'barry@broker.com'
    fill_in 'Password', with: 'barry'
    fill_in 'Confirm Password', with: 'barry'

    all('button', text: 'Add User').first.click

    expect(page).to have_content('Pick a plan')

    within "ul.plan.basic" do
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
    expect(page).to have_content('Create New Group')

    current_user = current_user_data
    expect(current_user['first_name']).to eq('Barry')
    expect(current_user['last_name']).to eq('Broker')
    expect(current_user['email']).to eq('barry@broker.com')
    expect(current_user['invitation_id']).to be_nil
    expect(current_user['is_admin']).to be_falsey
    expect(current_user['accounts'].length).to eq(1)

    current_account = current_user['accounts'].first
    expect(current_account['plan_name']).to eq('basic')
  end

  scenario "allows them to sign up for a standard plan" do
    visit '/'

    all('a', text: 'Sign Up').first.click

    fill_in 'First Name', with: 'Barry'
    fill_in 'Last Name', with: 'Broker'
    fill_in 'Email', with: 'barry@broker.com'
    fill_in 'Password', with: 'barry'
    fill_in 'Confirm Password', with: 'barry'

    all('button', text: 'Add User').first.click

    expect(page).to have_content('Pick a plan')

    within "ul.plan.standard" do
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
    expect(page).to have_content('Create New Group')

    current_user = current_user_data
    expect(current_user['first_name']).to eq('Barry')
    expect(current_user['last_name']).to eq('Broker')
    expect(current_user['email']).to eq('barry@broker.com')
    expect(current_user['invitation_id']).to be_nil
    expect(current_user['is_admin']).to be_falsey
    expect(current_user['accounts'].length).to eq(1)

    current_account = current_user['accounts'].first
    expect(current_account['plan_name']).to eq('standard')
  end

  scenario "allows them to sign up for a premier plan" do
    visit '/'

    all('a', text: 'Sign Up').first.click

    fill_in 'First Name', with: 'Barry'
    fill_in 'Last Name', with: 'Broker'
    fill_in 'Email', with: 'barry@broker.com'
    fill_in 'Password', with: 'barry'
    fill_in 'Confirm Password', with: 'barry'

    all('button', text: 'Add User').first.click

    expect(page).to have_content('Pick a plan')

    within "ul.plan.premier" do
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
    expect(page).to have_content('Create New Group')

    current_user = current_user_data
    expect(current_user['first_name']).to eq('Barry')
    expect(current_user['last_name']).to eq('Broker')
    expect(current_user['email']).to eq('barry@broker.com')
    expect(current_user['invitation_id']).to be_nil
    expect(current_user['is_admin']).to be_falsey
    expect(current_user['accounts'].length).to eq(1)

    current_account = current_user['accounts'].first
    expect(current_account['plan_name']).to eq('premier')
  end
end
