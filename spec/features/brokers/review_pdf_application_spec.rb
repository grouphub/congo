require "rails_helper"

feature "Broker review pdf application", :js do
  let!(:broker)  { create(:user, :broker) }
  let!(:account) { broker.roles.first.account }
  let!(:group)   { create(:group, account: account, slug: "group_test1") }
  let!(:account_benefit_plan) { create(:account_benefit_plan, account: account) }
  let!(:membership) { create(:membership, :with_user, group: group, account: group.account) }

  background { sign_in broker  }

  scenario "opens the pdf in a new tab" do
    upload_application_pdf
    click_on "Review"

    sleep 1

    expect(page).to have_content 'Review Application'
  end
end
