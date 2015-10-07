require 'rails_helper'

feature 'Customer authentication', :js do
  before { ActionMailer::Base.deliveries = [] }
  let(:customer) { create(:user, :customer) }
  let(:broker)   { create(:user, :broker) }
  let(:account)   { broker.roles.first.account }

  scenario 'allows them to sign in and out' do
    sign_in customer
    sign_out customer
  end

  scenario 'allows them to be invited to an account' do
    create_group_for(account)

    sign_in broker

    all('a', text: 'Groups').first.click

    expect(page).to have_content('Select benefits options')

    all('a', text: 'My Group').first.click

    expect(page).to have_content('Benefit Plans')

    click_on "Members"

    within 'form.invite-member' do
      fill_in 'Invite a New Member', with: 'alice@first-account.com'
      click_on "Invite a Member"
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

    within 'form.member' do
      fill_in 'First Name', with: 'Alice'
      fill_in 'Last Name', with: 'Foo'
      fill_in 'Email', with: 'alice@first-account.com'
      fill_in 'Password', with: 'testtest'
      fill_in 'Confirm Password', with: 'testtest'

      all('button', text: 'Activate').first.click
    end

    # Welcome flash should be present
    expect(page).to have_content('Welcome, Alice Foo!')

    # Dashboard heading should be present
    expect(page).to have_content('Welcome, Alice!')
  end

  scenario 'allows them user to be invited to an account as a customer' do
    create_group_for(account)

    sign_in broker

    all('a', text: 'Groups').first.click

    expect(page).to have_content('Select benefits options')

    all('a', text: 'My Group').first.click

    expect(page).to have_content('Benefit Plans')

    click_on "Members"

    within 'form.invite-member' do
      fill_in 'Invite a New Member', with: 'barry@broker.com'
      click_on 'Invite a Member'
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

    find('form.existing-account').click

    within 'form.existing-account' do
      expect(page).to have_content('Already have an account?')

      fill_in 'Email', with: 'barry@broker.com'
      fill_in 'Password', with: 'supersecret'

      all('button', text: 'Sign In').first.click
    end

    # Welcome flash should be present
    expect(page).to have_content("Welcome, #{broker.first_name} #{broker.last_name}!")

    # Dashboard heading should be present
    expect(page).to have_content("Welcome, #{broker.first_name}!")

    all('a', text: broker.first_name).first.click

    # Make sure that customer account appears in list
    expect(all('ul.dropdown-menu').first.text).to \
      eq "Accounts First Account Broker First Account Customer Groups My Group Group My Profile Sign Out"
  end
end
