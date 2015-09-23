require "rails_helper"

feature "Broker uploading form to a specific employee", :js do
  let(:user)    { create(:user, :broker) }
  let(:group)   { create(:group, account: account) }
  let(:account) { user.roles.first.account }
  let(:membership) { create(:membership, group: group, account: group.account) }

  let!(:account_benefit_plan) { create(:account_benefit_plan, account: account) }

  background { signin_broker(user) }

  context "when there are existing memberships" do
    before { membership }

    scenario "Showing a list of the active plans for that group and selecting a plan" do
      visit "/accounts/#{account.slug}/broker/groups/#{group.slug}"
      click_on "Members"
      click_on "Upload Application"

      expect(page).to have_content "Select PDF"
    end

    scenario "Uploading a file to an existing member" do
      visit "/accounts/#{account.slug}/broker/groups/#{group.slug}"

      click_on "Members"
      click_on "Upload Application"

      attach_file "Select PDF", "#{Rails.root}/spec/data/aetna-summary.pdf"
      select account_benefit_plan.name, from: "Select Plan"

      click_on "Upload"

      expect(page).to have_content "Successfully uploaded application PDF"
    end
  end


  scenario "Uploading a file to an existing member" do
    visit "/accounts/#{account.slug}/broker/groups/#{group.slug}"

    click_on "Members"

    within "form.invite-member" do
      fill_in "email", with: Faker::Internet.email
      click_on "Invite a Member"
    end

    click_on "Upload Application"

    attach_file "Select PDF", "#{Rails.root}/spec/data/aetna-summary.pdf"
    select account_benefit_plan.name, from: "Select Plan"

    click_on "Upload"

    expect(page).to have_content "Successfully uploaded application PDF"
  end
end
