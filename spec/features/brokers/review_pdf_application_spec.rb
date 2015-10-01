require "rails_helper"

feature "Broker review pdf application", :js do
  let!(:broker)  { create(:user, :broker) }
  let!(:account) { broker.roles.first.account }
  let!(:group)   { create(:group, account: account, slug: "group_test1") }
  let!(:account_benefit_plan) { create(:account_benefit_plan, account: account) }
  let!(:membership) { create(:membership, :with_user, group: group, account: group.account) }

  let(:pdf_window) { page.driver.browser.window_handles.last }

  background { sign_in broker  }

  scenario "opens the pdf in a new tab" do
    upload_application_pdf
    click_on "Review"

    sleep 1

    expect(page.driver.browser.window_handles.count).to be > 1
  end

  def upload_application_pdf
    visit "/accounts/#{account.slug}/broker"
    click_on group.name

    click_on "Members"
    click_on "Upload Application"

    attach_file "Select PDF", "#{Rails.root}/spec/data/aetna-summary.pdf"
    select account_benefit_plan.name, from: "Select Plan"

    click_on "Upload"
  end
end
