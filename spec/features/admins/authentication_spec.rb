require 'rails_helper'

describe 'As an admin', js: true do

  describe 'Authentication' do

    it 'allows them to sign in and out' do
      create_admin
      signin_admin
      signout_admin
    end

  end

end

