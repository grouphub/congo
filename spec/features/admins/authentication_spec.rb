require 'rails_helper'

feature 'Admins authentication', :js do
  scenario 'allows them to sign in and out' do
    create_admin
    signin_admin
    signout_admin
  end
end
