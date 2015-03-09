require 'rails_helper'

describe 'As an admin', js: true do

  describe 'Authentication' do

    it 'allows them to sign in and out' do
      create_admin
      signin_admin
      signout_admin
    end

  end

  describe 'Carriers' do

    it 'allows them to create a carrier'
    it 'allows them to delete a carrier'
    it 'allows them view a carrier'

  end

  describe 'Invitations' do

    it 'allows them to create a new invitation'
    it 'allows them to revoke an invitation'

  end

  describe 'All Accounts' do

    it 'allows them to view all accounts'

  end

  describe 'All Groups' do

    it 'allows them to view all groups'

  end

  describe 'Features' do

    it 'allows a new feature to be enabled for all accounts'
    it 'allows a new feature to be enabled for specific accounts'
    it 'allows a feature to be updated'
    it 'allows a feature to be deleted'

  end

end

