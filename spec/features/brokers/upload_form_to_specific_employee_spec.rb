require "rails_helper"

feature "Broker uploading form to a specific employee", :js do
  let!(:broker)  { create(:user, :broker) }
  let!(:account) { broker.roles.first.account }
  let!(:group)   { create(:group, account: account, slug: "group_test1") }
  let!(:account_benefit_plan) { create(:account_benefit_plan, account: account) }

  background { sign_in broker  }

  context "when there are existing memberships" do
    let!(:membership) { create(:membership, :with_user, group: group, account: group.account) }

    scenario "Showing a list of the active plans for that group and selecting a plan" do
      visit "/accounts/#{account.slug}/broker"
      click_on group.name

      click_on "Members"
      click_on "Upload Application"

      expect(page).to have_content "Select PDF"
    end

    scenario "Uploading a file to an existing member" do
      visit "/accounts/#{account.slug}/broker"
      click_on group.name

      click_on "Members"
      click_on "Upload Application"

      attach_file "Select PDF", "#{Rails.root}/spec/data/aetna-summary.pdf"
      select account_benefit_plan.name, from: "Select Plan"

      click_on "Upload"

      expect(page).to have_content "Successfully uploaded application PDF"
      expect(page).to have_content "Review"
    end
  end

  scenario "Uploading a file to an existing member" do
    visit "/accounts/#{account.slug}/broker"
    click_on group.name

    click_on "Members"

    within "form.invite-member" do
      fill_in "email", with: Faker::Internet.email
      click_on "Add member"
    end

    click_on "Upload Application"

    attach_file "Select PDF", "#{Rails.root}/spec/data/aetna-summary.pdf"
    select account_benefit_plan.name, from: "Select Plan"

    click_on "Upload"

    expect(page).to have_content "Successfully uploaded application PDF"
  end
end
