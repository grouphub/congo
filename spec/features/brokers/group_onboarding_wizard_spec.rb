require "spec_helper"

feature "Brokers group onboarding wizard", :js do
  let(:broker) { create(:broker_user) }
  let(:account) { create(:broker_account) }
  let(:group) { account.groups.first }

  before { create(:broker_role, user_id: broker.id, account_id: account.id) }

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

    expect(find('.invited-membership-1').value).
      to have_content "johndoe@example.com"
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

    expect(find('.invited-membership-1').value).
      to have_content "johndoe@example.com"

    expect(find('.invited-membership-2').value).
      to have_content "foobar@example.com"
  end
end
