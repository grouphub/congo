require 'spec_helper'

describe Membership do

  describe '#create_email_token' do

    it 'creates an email token on save if one does not exist'
    it 'does not create an email token on save if one exists'

  end

  describe '#email' do

    it 'returns the email for the user if the user is present'
    it 'returns the email for the membership if the user is not present'

  end

  describe '#original_email' do

    it 'returns the email for the membership'

  end

  describe '#invoiceable?' do

    it 'returns false if the user does not exist' do
      membership = Membership.create!

      expect(membership.invoiceable?).to eq(false)
    end

    it 'returns false if the user exists and is within the grace period' do
      user = User.create! \
        email: 'foo@bar.com'

      membership = Membership.create! \
        user_id: user.id

      expect(membership.invoiceable?).to eq(false)
    end

    it 'returns true if the user exists and is outside the grace period' do
      user = User.create! \
        email: 'foo@bar.com'

      membership = Membership.create! \
        user_id: user.id,
        created_at: 3.days.ago

      expect(membership.invoiceable?).to eq(true)
    end

  end

end

