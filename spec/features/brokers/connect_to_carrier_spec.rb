require 'rails_helper'

feature "Broker connects to carrier", :js do
  let!(:broker)  { create(:user, :broker) }
  let!(:account) { broker.roles.first.account }
  let!(:group)   { create(:group, account: account, slug: "group_test1") }
  let(:carrier) { create(:carrier) }


  background { sign_in broker  }

  scenario "canceling invoice file uploading" do
    visit "/accounts/#{account.slug}/broker/groups/#{group.slug}/add_existing_benefits"

    all('a', text: 'Add to Account').first.click

    find('button.close').click

    expect(all(".modal-dialog").present?).to be false
  end

  scenario "uploading an invoice file" do
    carrier

    visit "/accounts/#{account.slug}/broker/groups/#{group.slug}/add_existing_benefits"

    all('a', text: 'Add to Account').first.click

    page.execute_script("$('#carrier-invoice').removeClass('hidden')")

    attach_file("carrier-invoice", "#{Rails.root}/spec/data/carrier_invoice.txt")

    click_on "Connect & Save"

    expect(page).to have_content("Successfully connected to carrier.")
  end
end
