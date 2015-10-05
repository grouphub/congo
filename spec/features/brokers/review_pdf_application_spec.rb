require "rails_helper"

feature "Broker review pdf application", :js do
  let!(:broker)  { create(:user, :broker) }
  let!(:account) { broker.roles.first.account }
  let!(:group)   { create(:group, account: account, slug: "group_test1") }
  let!(:account_benefit_plan) { create(:account_benefit_plan, account: account) }
  let!(:membership) { create(:membership, :with_user, group: group, account: group.account) }

  let(:pdf_window) { page.driver.browser.window_handles.last }

  background { signin_broker broker  }

  scenario "opens the pdf in a new tab" do
    upload_application_pdf
    click_on "Review"

    sleep 1

    within "#review-application-modal" do
      click_on "Open PDF"
    end

    expect(page.driver.browser.window_handles.count).to be > 1
  end
end
