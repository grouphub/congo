require 'rails_helper'

feature 'Broker forgot password', :js do
  let!(:broker) { create(:user, :broker) }

  before { ActionMailer::Base.deliveries = [] }

  scenario 'allows them to request a password reset' do
    visit '/'

    all('a', text: 'Sign In').first.click
    all('a', text: 'Forgot your password?').first.click

    fill_in 'email', with: 'barry@broker.com'

    expect(ActionMailer::Base.deliveries).to be_empty

    all('[type="submit"][value="Reset Password"]').first.click

    wait_for('email to be delivered') do
      ActionMailer::Base.deliveries.length == 1
    end

    expect(page).to have_content('An email has been sent to barry@broker.com. Check your email for instructions.')

    user = User.find_by_email('barry@broker.com')
    expect(user.password).to eq('')
    expect(user.password_token).to be_a_thirty_six

    email = ActionMailer::Base.deliveries.last
    email_body = email.body.to_s
    email_html = Nokogiri::HTML(email_body)
    forgot_password_link = email_html.css('a:contains("Reset Your Password")')
    forgot_password_url = forgot_password_link.attr('href').value

    visit forgot_password_url

    expect(page).to have_content('Reset My Password')

    fill_in 'Password', with: 'newpassword'
    fill_in 'Confirm Password', with: 'newpassword'

    all('[type="submit"][value="Reset Password"]').first.click

    expect(page).to have_content('Sign In')

    user = User.find_by_email('barry@broker.com')
    expect(user.password).to eq('newpassword')
    expect(user.password_token).to be_nil
  end
end
