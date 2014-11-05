describe Api::V1::UsersController do
  describe 'POST /api/v1/users.json' do
    it 'creates a broker' do
      post :create, \
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
      expect(user.password == 'acorns').to eq true

      expect(user.roles.length).to eq 2
      expect(user.roles.first.name).to eq 'broker'
      expect(user.roles.last.name).to eq 'group_admin'

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
        email_token: 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'

      post :create, \
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
      expect(user.password == 'acorns').to eq true
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

    it 'responds with an error when the password does not match the confirmation'
    it 'responds with an error when creating a customer with no matching membership'
  end

  describe 'PUT /api/v1/users/:id.json' do
  end

  describe 'POST /api/v1/users/signin' do
  end

  describe 'DELETE /api/v1/users/signout' do
  end
end

