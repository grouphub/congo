require 'rails_helper'

describe 'As a broker', js: true do

  describe 'Groups' do

    before(:each) do
      create_broker
      signin_broker

      @broker_account = Role.find_by_name('broker').account

      visit "/accounts/#{@broker_account.slug}/broker/groups/new"
    end

    context 'Creating a group' do
      it 'allows them to create a group' do
        fill_in 'name', with: 'My first group'
        click_button 'Create Group'

        expect(page).to have_content("Welcome to your #{@broker_account.slug.capitalize} Account.")
      end

      it 'allows them to cancel the creation of a group' do
        fill_in 'name', with: 'My first group'
        click_link 'Cancel'

        expect(current_path).to eq("/accounts/#{@broker_account.slug}/broker/groups")
      end

      it 'allows them to view a group' do
        fill_in 'name', with: 'My first group'
        click_button 'Create Group'

        visit "/accounts/#{@broker_account.slug}/broker/groups"

        expect(page).to have_content(@broker_account.groups.first.name)
      end

      it 'allows shows welcome page afterwards' do
        fill_in 'name', with: 'My first group'
        click_button 'Create Group'

        expect(page).to have_content('Welcome to your')
      end
    end

    it 'allows them to delete a group'
    it 'allows them to enable and disable a group'

    describe 'Benefit Plans' do

      it 'allows them to add a benefit plan to a group'
      it 'allows them to remove a benefit plan from a group'
      it 'hides the button to add a benefit plan if there are no remaining enabled benefit plans'

    end

    describe 'Members' do

      it 'allows for a new member to be invited'
      it 'allows for a new member to be revoked'
      it 'allows for an invitation to be sent'
      it 'allows for an invitation to be sent to all pending members'
      it 'allows for a member profile to be viewed'

      describe 'Applications' do

        it 'shows when a user has applied for a plan'
        it 'shows when a user has declined a plan'
        it 'allows for an application to be reviewed and approved'
        it 'allows for an application status to be seen'

      end

    end

    describe 'Group Admins' do

      it 'allows for a new member to be invited'
      it 'allows for a new member to be revoked'
      it 'allows for an invitation to be sent'
      it 'allows for an invitation to be sent to all pending members'
      it 'allows for a member profile to be viewed'

    end

  end

end

