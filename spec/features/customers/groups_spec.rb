require 'rails_helper'

describe 'As a customer', js: true do

  describe 'Groups' do

    it 'allows them to see enabled groups'
    it 'prevents them from seeing disabled groups'
    it 'allows them to see enabled benefit plans in a group'
    it 'prevents them from seeing disabled benefit plans in a group'
    it 'allows them to decline a plan'

    it 'allows them to select and apply for a plan' do
      create_broker

      account = Account.find_by_name('First Account')

      create_group_for(account)
      create_customer

      group = Group.find_by_name('My Group')
      role = Role.find_by_name('customer')
      customer = role.user

      Membership.create! \
        group_id: group.id,
        user_id: customer.id,
        role_id: role.id,
        email: customer.email

      signin_customer

      all('a[title="Groups"]').first.click

      expect(page).to have_content('Select benefits options')

      all('a', text: 'My Group').first.click

      expect(page).to have_content('Benefit Plans')
      expect(page).to have_content('Best Health Insurance PPO')

      all('a', text: 'Select').first.click

      expect(page).to have_content('Benefits Enrollment Application')

      scroll_to_element_in('h3:contains("Primary Applicant")', 'main')

      within '[name="subscriber"]' do
        expect(page).to have_content('Primary Applicant')
      end

      # binding.pry
    end

  end

end

