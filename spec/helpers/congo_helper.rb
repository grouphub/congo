require 'rails_helper'

module CongoHelper

  def create_admin
    test_debug 'Creating an admin account...'

    account = create(:admin_account)

    user = create(:admin_user)

    create(:admin_role, user_id: user.id, account_id: account.id)
  end

  def signin_admin
    test_debug 'Signing in as an admin...'

    admin = Role.find_by_name('admin').user

    visit '/'

    all('a', text: 'Sign In').first.click

    expect(page).to have_content('Email')

    fill_in 'Email', with: admin.email
    fill_in 'Password', with: 'testtest'

    all('button', text: 'Sign In').first.click

    expect(page).to have_content('Administrator Dashboard')
  end

  def signout_admin
    test_debug 'Signing out as an admin...'

    all('a', text: 'GroupHub').first.click

    expect(page).to have_content('Sign Out')

    all('a', text: 'Sign Out').first.click

    expect(page).to have_content('You have signed out.')
    expect(page).to have_content('The next generation')
  end

  def create_broker
    test_debug 'Creating a broker account...'

    account = create(:broker_account)

    user = create(:broker_user)

    create(:broker_role, user_id: user.id, account_id: account.id)
  end

  def signin_broker
    test_debug 'Signing in as a broker...'

    broker = Role.find_by_name('broker').user

    visit '/'

    all('a', text: 'Sign In').first.click

    expect(page).to have_content('Email')

    fill_in 'Email', with: broker.email
    fill_in 'Password', with: 'barry'

    all('button', text: 'Sign In').first.click

    expect(page).to have_content('Broker Dashboard: First Account')
  end

  def signout_broker
    test_debug 'Signing out as a broker...'

    all('a', text: 'Barry').first.click

    expect(page).to have_content('Sign Out')

    all('a', text: 'Sign Out').first.click

    expect(page).to have_content('You have signed out.')
    expect(page).to have_content('The next generation')
  end

  def create_customer
    test_debug 'Creating a customer account...'

    account = Account.create \
      name: 'First Account',
      tagline: '#1 Account',
      plan_name: 'basic',
      properties: {
        name: 'First Account',
        tagline: '#1 Account',
        plan_name: 'basic'
      }

    user = User.create \
      first_name: 'Candice',
      last_name: 'Customer',
      email: 'candice@customer.com',
      password: 'candice'

    Role.create \
      user_id: user.id,
      account_id: account.id,
      name: 'customer'
  end

  def signin_customer
    test_debug 'Signing in as a customer...'

    visit '/'

    all('a', text: 'Sign In').first.click

    expect(page).to have_content('Email')

    fill_in 'Email', with: 'candice@customer.com'
    fill_in 'Password', with: 'candice'

    all('button', text: 'Sign In').first.click

    expect(page).to have_content('Welcome, Candice!')
  end

  def signout_customer
    test_debug 'Signing out as a customer...'

    all('a', text: 'Candice').first.click

    expect(page).to have_content('Sign Out')

    all('a', text: 'Sign Out').first.click

    expect(page).to have_content('You have signed out.')
    expect(page).to have_content('The next generation')
  end

  def create_group_for(account)
    test_debug 'Creating a carrier, carrier account, benefit plan, group, and group benefit plan...'

    carrier = Carrier.create! \
      name: 'Blue Cross',
      properties: {
        npi: '1467560003',
        first_name: 'Brad',
        last_name: 'Bluecross',
        service_types: ['health_benefit_plan_coverage'],
        trading_partner_id: 'MOCKPAYER'
      }

    carrier_account = CarrierAccount.create! \
      name: 'My Broker Blue Cross',
      carrier_id: carrier.id,
      account_id: account.id

    benefit_plan = BenefitPlan.create! \
      account_id: account.id,
      carrier_account_id: carrier_account.id,
      name: 'Best Health Insurance PPO',
      is_enabled: true

    group = Group.create! \
      account_id: account.id,
      name: 'My Group',
      is_enabled: true

    GroupBenefitPlan.create! \
      group_id: group.id,
      benefit_plan_id: benefit_plan.id
  end

  def current_user_data
    page.evaluate_script('window.congo.currentUser')
  end

  def sample_application
    JSON.load File.read("#{Rails.root}/spec/data/application.json")
  end

  def sign_in(user)
    test_debug 'Signing in as a broker...'

    visit '/'

    all('a', text: 'Sign In').first.click

    expect(page).to have_content('Email')

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'supersecret'

    all('button', text: 'Sign In').first.click

    expect(page).to have_content(user.first_name)
  end
end
