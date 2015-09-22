require 'spec_helper'

describe User do
  describe '#password' do
    it 'returns a password hash' do
      user = User.new
      user.password = 'foo'

      expect(user.password.length).to eq(60)
    end
  end

  describe '#password=' do
    it 'allows a password to be set' do
      user = User.new
      user.password = 'foo'

      expect(user.password).to eq('foo')
    end
  end

  describe '#full_name' do
    it 'returns a full name for a user with a first and last name' do
      user = User.new
      user.first_name = 'Britney'
      user.last_name = 'Spears'

      expect(user.full_name).to eq('Britney Spears')
    end

    it 'returns a first name for a user with only a first name' do
      user = User.new
      user.first_name = 'Britney'

      expect(user.full_name).to eq('Britney')
    end

    it 'returns a last name for a user with only a last name' do
      user = User.new
      user.last_name = 'Spears'

      expect(user.full_name).to eq('Spears')
    end
  end

  describe 'admin?' do
    it 'returns true if a user is an admin' do
      user = User.create!

      Role.create!(name: 'admin', user_id: user.id)
      Role.create!(name: 'broker', user_id: user.id)

      expect(user.admin?).to eq(true)
    end

    it 'returns false if a user is not an admin' do
      user = User.create!

      Role.create!(name: 'customer', user_id: user.id)
      Role.create!(name: 'broker', user_id: user.id)

      expect(user.admin?).to eq(false)
    end

    it 'returns false if a user has no roles' do
      user = User.create!

      expect(user.admin?).to eq(false)
    end
  end

  describe '#nuke!' do
    it 'destroys a user and all associated data' do
      user = User.create!(email: 'wanda@foo.com')
      user_2 = User.create!(email: 'virgil@foo.com')
      membership = Membership.create!(user_id: user.id)
      membership_2 = Membership.create!(user_id: user_2.id)
      application = Application.create!(membership_id: membership.id)
      application_2 = Application.create!(membership_id: membership_2.id)
      application_status = ApplicationStatus.create!(application_id: application.id)
      application_status_2 = ApplicationStatus.create!(application_id: application_2.id)

      user.nuke!

      expect(User.where(id: user.id)).to_not be_present
      expect(Membership.where(id: membership.id)).to_not be_present
      expect(Application.where(id: application.id)).to_not be_present
      expect(ApplicationStatus.where(id: application_status.id)).to_not be_present

      expect(User.where(id: user_2.id)).to be_present
      expect(Membership.where(id: membership_2.id)).to be_present
      expect(Application.where(id: application_2.id)).to be_present
      expect(ApplicationStatus.where(id: application_status_2.id)).to be_present
    end
  end
end
