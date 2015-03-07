require 'rails_helper'

describe 'Authentication', js: true do

  describe 'as an administrator' do

    it 'allows an administrator to sign in and out' do
      create_admin
      signin_admin
      signout_admin
    end

  end

end

