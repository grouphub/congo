require "rails_helper"

feature "Brokers delete pdf application", :js do
  let!(:broker)  { create(:user, :broker) }
  let!(:account) { broker.roles.first.account }
  let!(:group)   { create(:group, account: account, slug: "group_test1") }
  let!(:account_benefit_plan) { create(:account_benefit_plan, account: account) }
  let!(:membership) { create(:membership, :with_user, group: group, account: group.account) }

  background { signin_broker(broker) }

  scenario "when there is a submitted pdf application" do
    upload_application_pdf

    click_on "Delete"

    expect(page).to_not have_content("Review")
  end
end
