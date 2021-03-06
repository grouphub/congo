require "rails_helper"

feature 'API Tokens', :js do
  let(:broker)  { create(:user, :broker) }
  let(:account) { broker.roles.first.account }

  scenario 'allows a broker to see a list of API tokens' do
    pending 'It seems the Manage API Tokens element was removed from UX(?)'

    Feature.create! \
      name: 'api_tokens',
      account_slugs: %w[first_account]

    sign_in broker

    Token.create! \
      account_id: account.id,
      name: "Token #1"

    Token.create! \
      account_id: account.id,
      name: "Token #2"

    all('a', text: 'Manage API Tokens').first.click

    within 'table.tokens' do
      tds = all('td')

      expect(tds.length).to eq(6)

      name_1 = tds[0]
      unique_id_1 = tds[1]
      name_2 = tds[3]
      unique_id_2 = tds[4]

      expect(name_1).to have_content('Token #1')
      expect(unique_id_1.text).to be_a_thirty_six
      expect(name_2).to have_content('Token #2')
      expect(unique_id_2.text).to be_a_thirty_six
    end
  end

  scenario 'allows a broker to create a new API token' do
    pending 'It seems the Manage API Tokens element was removed from UX(?)'

    Feature.create! \
      name: 'api_tokens',
      account_slugs: %w[first_account]

    sign_in broker

    all('a', text: 'Manage API Tokens').first.click

    fill_in 'Name', with: 'For Enrollment'

    all('input[type=submit]').first.click

    expect(page).to have_content('For Enrollment')

    within 'table.tokens' do
      tds = all('td')

      expect(tds.length).to eq(3)

      name = tds[0]
      unique_id = tds[1]

      expect(name).to have_content('For Enrollment')
      expect(unique_id.text).to be_a_thirty_six
    end
  end

  scenario 'allows a broker to remove an existing API token' do
    pending 'It seems the Manage API Tokens element was removed from UX(?)'

    # Should not need this. This is to fix test wobbles. Token from previous
    # test is sometimes sticking around.
    Token.destroy_all

    Feature.create! \
      name: 'api_tokens',
      account_slugs: %w[first_account]

    Token.create! \
      account_id: account.id,
      name: "Token #1"

    sign_in broker

    all('a', text: 'Manage API Tokens').first.click

    within 'table.tokens' do
      expect(page).to have_content('Token #1')

      all('a', text: 'Delete').first.click

      wait_for('AJAX to finish') do
        !page.text.match(/Token \#1/)
      end

      expect(page).to have_no_content('Token #1')
    end
  end
end
