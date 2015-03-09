require 'rails_helper'

describe 'As an administrator', js: true do

  it 'allows an administrator to sign in and out' do
    create_admin
    signin_admin
    signout_admin
  end

end

