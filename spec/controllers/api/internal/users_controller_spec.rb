require 'spec_helper'

describe Api::Internal::UsersController do

  describe 'POST /api/internal/users.json' do

    it 'creates a broker' do
      User.destroy_all

      email = Faker::Internet.email

      post :create,
        format: 'json',
        email: email,
        first_name: 'Alvin',
        last_name: 'Chipmunk',
        password: 'acorns',
        password_confirmation: 'acorns',
        type: 'broker'

      user = User.last
      expect(user.email).to eq email
      expect(user.first_name).to eq 'Alvin'
      expect(user.last_name).to eq 'Chipmunk'

      expect(user.roles.length).to eq 1
      expect(user.roles.first.name).to eq 'broker'

      response_data = JSON.load(response.body)
      expect(response_data.keys.length).to eq 1

      user_data = response_data['user']
      expect(user_data['id']).to be > 0
      expect(user_data['email']).to eq email
      expect(user_data['first_name']).to eq 'Alvin'
      expect(user_data['last_name']).to eq 'Chipmunk'

      # TODO: Needs more assertions
      expect(user_data['accounts'].length).to eq 1

      expect(session['current_user_id']).to eq user_data['id']
    end

    it 'creates a customer' do
      account = Account.create \
        name: 'Cool Account'

      group = Group.create \
        name: 'Cool Group',
        account_id: account.id

      membership = Membership.create \
        group_id: group.id,
        email: Faker::Internet.email,
        email_token: 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        role_name: 'customer'

      post :create,
        format: 'json',
        email: membership.email,
        first_name: 'Alvin',
        last_name: 'Chipmunk',
        password: 'acorns',
        password_confirmation: 'acorns',
        type: 'customer',
        email_token: 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'

      user = User.last
      expect(user.email).to eq membership.email
      expect(user.first_name).to eq 'Alvin'
      expect(user.last_name).to eq 'Chipmunk'
      expect(user.roles.map(&:name)).to eq %w[customer]

      response_data = JSON.load(response.body)
      expect(response_data.keys.length).to eq 1

      user_data = response_data['user']
      expect(user_data['id']).to be > 0
      expect(user_data['email']).to eq membership.email
      expect(user_data['first_name']).to eq 'Alvin'
      expect(user_data['last_name']).to eq 'Chipmunk'

      # TODO: Needs more assertions
      expect(user_data['accounts'].length).to eq 1
    end

    it 'creates a group admin' do
      account = Account.create \
        name: 'Cool Account'

      group = Group.create \
        name: 'Cool Group',
        account_id: account.id

      membership = Membership.create \
        group_id: group.id,
        email: Faker::Internet.email,
        email_token: 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        role_name: 'group_admin'

      post :create,
        format: 'json',
        email: membership.email,
        first_name: 'Alvin',
        last_name: 'Chipmunk',
        password: 'acorns',
        password_confirmation: 'acorns',
        type: 'group_admin',
        email_token: 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'

      user = User.last
      expect(user.email).to eq membership.email
      expect(user.first_name).to eq 'Alvin'
      expect(user.last_name).to eq 'Chipmunk'
      expect(user.roles.map(&:name)).to eq %w[group_admin]

      response_data = JSON.load(response.body)
      expect(response_data.keys.length).to eq 1

      user_data = response_data['user']
      expect(user_data['id']).to be > 0
      expect(user_data['email']).to eq membership.email
      expect(user_data['first_name']).to eq 'Alvin'
      expect(user_data['last_name']).to eq 'Chipmunk'

      # TODO: Needs more assertions
      expect(user_data['accounts'].length).to eq 1
    end
  end
end
