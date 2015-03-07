require 'rails_helper'

describe 'Authentication', js: true do

  describe 'as a group admin' do

    it 'allows a group admin to sign in and out'
    it 'allows a group admin to be invited to an account'
    it 'allows an existing user to be invited to an account as a group admin'
    it 'prevents a customer from creating a new account with an existing email address'

  end

end

