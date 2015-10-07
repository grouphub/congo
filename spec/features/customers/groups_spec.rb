require 'rails_helper'

feature 'Customer groups', :js do
  let(:broker)  { create(:user, :broker) }
  let(:account) { broker.roles.first.account }

  pending 'allows them to select and apply for a plan' do
    create_group_for(account)

    group = Group.find_by_name('My Group')

    customer = User.create \
      first_name: 'Candice',
      last_name: 'Customer',
      email: 'candice@customer.com',
      password: 'candice'

    role = Role.create \
      user_id: customer.id,
      account_id: account.id,
      name: 'customer'

    Membership.create! \
      group_id: group.id,
      user_id: customer.id,
      role_id: role.id,
      email: customer.email

    sign_in customer

    expect(page).to have_content('Benefit Plans')

    all('a', text: 'Select').first.click

    expect(page).to have_content('Benefits Enrollment Application')

    scroll_to_element_in('h3:contains("Primary Applicant")', 'main')
    within '[name="subscriber"]' do
      expect(page).to have_content('Primary Applicant')

      fill_in 'First Name', with: 'Candice'
      fill_in 'Middle Name', with: 'C.'
      fill_in 'Last Name', with: 'Customer'
      choose 'Female'
      fill_in 'Social Security Number', with: '444-44-4444'
      fill_in 'Date of Birth (mm/dd/yyyy)', with: '04/04/1984'
      fill_in 'Employment Status', with: 'Full-Time'
      check 'Substance Abuse'
      check 'Tobacco Use'
      check 'Handicapped'
    end

    scroll_to_element_in('h3:contains("Contact Information")', 'main')
    within '[name="subscriberContact"]' do
      expect(page).to have_content('Contact Information')

      fill_in 'Street Address', with: '444 Carrie Ct.'
      fill_in 'Apt. #', with: '44'
      fill_in 'City', with: 'Cambridge'
      fill_in 'State', with: 'CA'
      fill_in 'ZIP', with: '44444'
      fill_in 'County', with: 'Contra Costa'
      fill_in 'Phone', with: '(444) 444-4444'
      fill_in 'Phone Type', with: 'Home'
      fill_in 'Other Phone', with: '(444) 444-5555'
      fill_in 'Other Phone Type', with: 'Work'
    end

    scroll_to_element_in('h3:contains("Previous Coverage")', 'main')
    within '[name="previousCoverage"]' do
      expect(page).to have_content('Previous Coverage')

      choose('Yes')
      fill_in 'Medical Record # (If Any)', with: '4444444'
      fill_in 'If Yes, Most Recent Insurance Carrier', with: 'Anthem Blue Cross'
      fill_in 'Dates of Coverage', with: '04/2014-08/2014'
    end

    scroll_to_element_in('h3:contains("Dependents to be Covered")', 'main')
    within '[name="dependents"]' do
      expect(page).to have_content('Dependents to be Covered')

      all('a', text: 'Add Dependent').first.click

      expect(page).to have_content('Dependent 1')

      fill_in 'First Name', with: 'Corwin'
      fill_in 'Middle Name', with: 'C.'
      fill_in 'Last Name', with: 'Customer'
      choose 'Male'
      fill_in 'Medical Record # (If Any)', with: '4444444'
      fill_in 'Social Security Number', with: '444-44-4445'
      fill_in 'Date of Birth (mm/dd/yyyy)', with: '04/04/2004'
      choose 'Yes'
      fill_in 'If Yes, Most Recent Insurance Carrier', with: 'Anthem Blue Cross'
      fill_in 'Dates of Coverage', with: '04/2014-08/2014'
      select 'Child', from: 'dependent_1_relationship'
    end

    all('input[type=submit]').first.click

    # TODO: Make sure there's a flash message

    expect(page).to have_content('Welcome, Candice!')

    application = Application.last
    properties = application.properties

    sample_application.each do |key, value|
      expect(properties[key]).to eq(value)
    end
  end
end
