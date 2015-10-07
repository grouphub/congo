require 'rails_helper'

feature 'Admins authentication', :js do
  let(:admin) { create(:user, :admin) }

  scenario 'allows them to sign in and out' do
    sign_in admin
    sign_out admin
  end
end
