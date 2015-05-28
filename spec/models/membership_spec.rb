require 'spec_helper'

describe Membership do

  describe '#create_email_token' do

    it 'can be called to populate the email token' do
      membership_2 = Membership.new

      expect(membership_2.email_token).to be_nil

      membership_2.create_email_token

      expect(membership_2.email_token).to be_a_thirty_six
    end

    it 'creates an email token on save if one does not exist' do
      membership = Membership.create!

      expect(membership.email_token).to be_a_thirty_six
    end

    it 'does not create an email token on save if one exists' do
      membership = Membership.create! \
        email_token: 'foo'

      expect(membership.email_token).to eq('foo')
    end

  end

  describe '#email' do

    it 'returns the email for the user if the user is present' do
      membership = Membership.create! \
        email: 'foo@bar.com'

      user = User.create! \
        email: 'bar@baz.com'

      membership_2 = Membership.create! \
        user_id: user.id,
        email: 'foo@bar.com'

      expect(membership.email).to eq('foo@bar.com')
      expect(membership_2.email).to eq('bar@baz.com')
    end

  end

  describe '#original_email' do

    it 'returns the email for the membership' do
      membership = Membership.create! \
        email: 'foo@bar.com'

      user = User.create! \
        email: 'bar@baz.com'

      membership_2 = Membership.create! \
        user_id: user.id,
        email: 'foo@bar.com'

      expect(membership.original_email).to eq('foo@bar.com')
      expect(membership_2.original_email).to eq('foo@bar.com')
    end

  end

  describe '#employee?' do

    it 'returns true if the member is an employee' do
      membership = Membership.create! \
        role_name: 'employee'

      role = Role.create! \
        name: 'employee'

      membership_2 = Membership.create! \
        role_id: role.id

      expect(membership.employee?).to eq(true)
      expect(membership_2.employee?).to eq(true)
    end

    it 'returns false if the member is an employee' do
      membership = Membership.create! \
        role_name: 'group_admin'

      role = Role.create! \
        name: 'group_admin'

      membership_2 = Membership.create! \
        role_id: role.id

      membership_3 = Membership.create!

      expect(membership.employee?).to eq(false)
      expect(membership_2.employee?).to eq(false)
      expect(membership_3.employee?).to eq(false)
    end

  end

  describe '#invoiceable?' do

    it 'returns false if the user does not exist' do
      membership = Membership.create!

      expect(membership.invoiceable?).to eq(false)
    end

    it 'returns false if the user is not an employee' do
      membership = Membership.create! \
        role_name: 'group_admin'

      role = Role.create! \
        name: 'group_admin'

      membership_2 = Membership.create! \
        role_id: role.id

      expect(membership.invoiceable?).to eq(false)
      expect(membership_2.invoiceable?).to eq(false)
    end

    it 'returns false if the user exists and is within the grace period' do
      user = User.create! \
        email: 'foo@bar.com'

      role = Role.create! \
        name: 'employee'

      membership = Membership.create! \
        role_id: role.id,
        user_id: user.id

      expect(membership.invoiceable?).to eq(false)
    end

    it 'returns true if the user exists and is outside the grace period' do
      user = User.create! \
        email: 'foo@bar.com'

      role = Role.create! \
        name: 'employee'

      membership = Membership.create! \
        role_id: role.id,
        user_id: user.id,
        created_at: 3.days.ago

      expect(membership.invoiceable?).to eq(true)
    end

  end

end

