require "spec_helper"

feature "Brokers group onboarding wizard", :js do
  let(:broker) { create(:user, :broker) }
  let(:account) { broker.roles.first.account }
  let(:group) { account.groups.first }
  let(:memberships) { group.memberships }

  background { sign_in broker }

  scenario "creating new group and adding individual members" do
    visit "/accounts/#{account.slug}/broker/groups/new"
    expect(page).to have_content "Create New Group"

    fill_in "Group Name", with: "Google employees"
    click_on "Create Group"

    expect(page).to have_content "Lets setup your group in just a few steps."

    click_on "Get Started"

    expect(page).to have_content "Google employees Details"

    select rand(1..11), from: "Number of Members*"
    select "Information Technology", from: "Industry"
    fill_in "Website", with: "https://google.com"
    fill_in "Phone Number*", with: "55000000"
    fill_in "ZIP Code", with: "94000"
    fill_in "Tax ID", with: "12345"

    click_on "Save & Continue"

    expect(page).to have_content "Add Members"

    click_on "Add Members Now"

    expect(page).to have_content "Add New Member"

    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Doe"
    fill_in "Phone", with: "55010000"
    fill_in "Email", with: "johndoe@example.com"

    click_on "Invite"

    expect(page).to have_content "Successfully added the member"

    visit "/accounts/#{account.slug}/broker/groups/#{group.slug}"

    click_on "Members"

    memberships.each do |membership|
      expect(find(".invited-membership-#{membership.id}").value).
        to have_content membership.email
    end
  end

  scenario "creating new group and adding members list" do
    visit "/accounts/#{account.slug}/broker/groups/new"
    expect(page).to have_content "Create New Group"

    fill_in "Group Name", with: "Google employees"
    click_on "Create Group"

    expect(page).to have_content "Lets setup your group in just a few steps."

    click_on "Get Started"

    expect(page).to have_content "Google employees Details"

    select rand(1..11), from: "Number of Members*"
    select "Information Technology", from: "Industry"
    fill_in "Website", with: "https://google.com"
    fill_in "Phone Number*", with: "55000000"
    fill_in "ZIP Code", with: "94000"
    fill_in "Tax ID", with: "12345"

    click_on "Save & Continue"

    expect(page).to have_content "Add Members"

    click_on "Upload Members List"

    expect(page).to have_content "Upload Members List"

    page.execute_script "$('#upload_employees_list').show().removeClass('hidden')"

    attach_file('upload_employees_list', Rails.root + 'spec/data/GroupHub_Employee_Template.csv')

    expect(page).to have_content "Successfully uploaded member list."

    visit "/accounts/#{account.slug}/broker/groups/#{group.slug}"

    click_on "Members"

    memberships.each do |membership|
      expect(find(".invited-membership-#{membership.id}").value).
        to have_content membership.email
    end
  end


  scenario 'allows them to cancel the creation of a group' do
    visit "/accounts/#{account.slug}/broker/groups/new"
    expect(page).to have_content "Create New Group"

    fill_in 'name', with: 'My first group'
    click_link 'Cancel'

    expect(current_path).to eq("/accounts/#{account.slug}/broker/groups")
  end

  scenario 'allows them to view a group' do
    visit "/accounts/#{account.slug}/broker/groups/new"
    expect(page).to have_content "Create New Group"

    fill_in 'name', with: 'My first group'
    click_button 'Create Group'

    visit "/accounts/#{account.slug}/broker/groups"

    expect(page).to have_content(group.name)
  end


  context 'A group already exist' do
    let!(:group) { create(:group, account: account) }

    scenario 'allows them to navigate to a group\'s Details page' do
      visit "/accounts/#{account.slug}/broker/groups/#{group.slug}/welcome"

      click_link 'Get Started'

      expect(current_path).to eq("/accounts/#{account.slug}/broker/groups/#{group.slug}/details")
    end

    scenario 'allows them to create the details of a group' do
      visit "/accounts/#{account.slug}/broker/groups/#{group.slug}/details"

      select rand(1..11), from: "Number of Members*"
      select "Information Technology", from: "Industry"

      fill_in 'website',      with: 'www.website.com'
      fill_in 'phone_number', with: '1111111111'
      fill_in 'zip_code',     with: '22222'
      fill_in 'tax_id',       with: '1234'

      click_button 'Save & Continue'

      sleep(1)
      expect(current_path).to eq("/accounts/#{account.slug}/broker/groups/#{group.slug}/members")
    end

    scenario 'allows them to skip details of a group' do
      visit "/accounts/#{account.slug}/broker/groups/#{group.slug}/details"

      click_link 'Skip'
      expect(current_path).to eq("/accounts/#{account.slug}/broker/groups/#{group.slug}/members")
    end

    context 'Adding members' do
      before(:each) do
        visit "/accounts/#{account.slug}/broker/groups/#{group.slug}/members"
      end

      scenario 'allows adding a member using "Add Members Now" button' do
        click_link 'Add Members Now'

        fill_in 'first_name', with: 'John'
        fill_in 'last_name', with: 'Doe'
        fill_in 'phone', with: '1111111111'
        fill_in 'email', with: 'john@doe.com'

        click_button 'Invite'
        expect(page).to have_content('Successfully added the member.')
      end

      scenario 'allows to skip "Add Members to Group" wizard' do
        click_link 'Do Later'

        expect(current_path).to eq("/accounts/#{account.slug}/broker/groups/#{group.slug}/benefits")
      end
    end

    context 'Benefits' do
      let!(:carrier1) { create(:carrier) }
      let!(:carrier2) { create(:carrier) }
      let!(:carrier3) { create(:carrier) }

      scenario 'allowing user to see benefits options' do
        visit "/accounts/#{account.slug}/broker/groups/#{group.slug}/benefits"

        expect(page).to have_content('Add Existing Benefits')
        expect(page).to have_content('Get Quotes')
        expect(page).to have_content('Do Later')
      end

      context 'Adding benefits' do
        background do
          visit "/accounts/#{account.slug}/broker/groups/#{group.slug}/add_existing_benefits"
        end

        scenario 'allows user to select existing benefits providers' do
          Carrier.all.map(&:name).each do |carrier|
            expect(page).to have_content(carrier)
          end
        end

        scenario 'allows user to see and filter benefits providers' do
          carrier_to_search =  Carrier.first.name
          carriers_hidden   =  Carrier.all.map(&:name) - [carrier_to_search]

          fill_in 'search-carrier', with: carrier_to_search

          expect(page).to have_content(carrier_to_search)

          carriers_hidden.each do |carrier_hidden|
            expect(page).to_not have_content(carrier_hidden)
          end
        end

        scenario 'allows user to do later the addition of benefits' do
          sleep 1

          page.execute_script("$('main').scrollTop(500)")

          click_on 'Do Later'

          expect(current_path).to eq("/accounts/#{account.slug}/broker/groups/#{group.slug}")
        end

        scenario 'allows user to establish a connection with carriers' do
          all('a', text: 'Add to Account').first.click

          expect(page).to have_content('Establish Carriers Connection')
        end
      end
    end
  end
end
