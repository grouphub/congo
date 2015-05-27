require 'spec_helper'

describe Api::Internal::UsersController do

  describe 'POST /api/internal/users.json' do

    it 'creates a broker' do
      post :create,
        format: 'json',
        email: 'alvin@chipmunks.com',
        first_name: 'Alvin',
        last_name: 'Chipmunk',
        password: 'acorns',
        password_confirmation: 'acorns',
        type: 'broker'

      user = User.last
      expect(user.email).to eq 'alvin@chipmunks.com'
      expect(user.first_name).to eq 'Alvin'
      expect(user.last_name).to eq 'Chipmunk'
      expect(user.password).to eq 'acorns'

      expect(user.roles.length).to eq 1
      expect(user.roles.first.name).to eq 'broker'

      response_data = JSON.load(response.body)
      expect(response_data.keys.length).to eq 1

      user_data = response_data['user']
      expect(user_data['id']).to be > 0
      expect(user_data['email']).to eq 'alvin@chipmunks.com'
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
        email: 'alvin@chipmunks.com',
        email_token: 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        role_name: 'customer'

      post :create,
        format: 'json',
        email: 'alvin@chipmunks.com',
        first_name: 'Alvin',
        last_name: 'Chipmunk',
        password: 'acorns',
        password_confirmation: 'acorns',
        type: 'customer',
        email_token: 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'

      user = User.last
      expect(user.email).to eq 'alvin@chipmunks.com'
      expect(user.first_name).to eq 'Alvin'
      expect(user.last_name).to eq 'Chipmunk'
      expect(user.password).to eq 'acorns'
      expect(user.roles.map(&:name)).to eq %w[customer]

      response_data = JSON.load(response.body)
      expect(response_data.keys.length).to eq 1

      user_data = response_data['user']
      expect(user_data['id']).to be > 0
      expect(user_data['email']).to eq 'alvin@chipmunks.com'
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
        email: 'alvin@chipmunks.com',
        email_token: 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        role_name: 'group_admin'

      post :create,
        format: 'json',
        email: 'alvin@chipmunks.com',
        first_name: 'Alvin',
        last_name: 'Chipmunk',
        password: 'acorns',
        password_confirmation: 'acorns',
        type: 'group_admin',
        email_token: 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'

      user = User.last
      expect(user.email).to eq 'alvin@chipmunks.com'
      expect(user.first_name).to eq 'Alvin'
      expect(user.last_name).to eq 'Chipmunk'
      expect(user.password).to eq 'acorns'
      expect(user.roles.map(&:name)).to eq %w[group_admin]

      response_data = JSON.load(response.body)
      expect(response_data.keys.length).to eq 1

      user_data = response_data['user']
      expect(user_data['id']).to be > 0
      expect(user_data['email']).to eq 'alvin@chipmunks.com'
      expect(user_data['first_name']).to eq 'Alvin'
      expect(user_data['last_name']).to eq 'Chipmunk'

      # TODO: Needs more assertions
      expect(user_data['accounts'].length).to eq 1
    end

    it 'responds with an error when the password does not match the confirmation'
    it 'responds with an error when creating a customer with no matching membership'
  end

  describe 'PUT /api/internal/users/:id.json' do
  end

  describe 'POST /api/internal/users/signin' do
  end

  describe 'DELETE /api/internal/users/signout' do
  end

end

