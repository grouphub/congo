require 'rails_helper'

module CongoHelper
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
    visit '/'

    all('a', text: 'Sign In').first.click

    expect(page).to have_content('Email')

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'supersecret'

    all('button', text: 'Sign In').first.click

    expect(page).to have_content(user.first_name)
  end

  def sign_out(user)
    all('a', text: user.first_name).first.click

    expect(page).to have_content('Sign Out')

    all('a', text: 'Sign Out').first.click

    expect(page).to have_content('You have signed out.')
    expect(page).to have_content('The next generation')
  end
end
