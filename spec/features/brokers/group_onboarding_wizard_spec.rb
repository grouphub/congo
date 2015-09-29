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

    it 'allows them to navigate to a group\'s Details page' do
      visit "/accounts/#{account.slug}/broker/groups/#{group.slug}/welcome"

      click_link 'Get Started'

      expect(current_path).to eq("/accounts/#{account.slug}/broker/groups/#{group.slug}/details")
    end

    scenario 'allows them to create the details of a group' do
      visit "/accounts/#{account.slug}/broker/groups/#{group.slug}/details"

      number_of_members_select = all('select').first
      industry_select          = all('select').last

      number_of_members_select.find(:xpath, 'option[2]').select_option
      industry_select.find(:xpath, 'option[2]').select_option

      fill_in 'website',      with: 'www.website.com'
      fill_in 'phone_number', with: '1111111111'
      fill_in 'zip_code',     with: '22222'
      fill_in 'tax_id',       with: '1234'

      click_button 'Save & Continue'

      #TODO: Check why this is not creating the group
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

        expect(current_path).to eq("/accounts/#{account.slug}/broker/groups/#{group.slug}")
      end
    end
  end
end
