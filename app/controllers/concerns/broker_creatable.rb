module BrokerCreatable
  extend ActiveSupport::Concern

  included do
    # Class methods here...
  end

  def attempt_to_create_broker!(params)
    email_token = params[:email_token]

    return if email_token

    first_name = params[:first_name]
    last_name = params[:last_name]
    email = params[:email]
    password = params[:password]

    user = User.create! \
      first_name: first_name,
      last_name: last_name,
      email: email,
      password: password

    account = Account.create!

    broker_role = Role
      .where({
        account_id: account.id,
        user_id: user.id,
        name: 'broker'
      })
      .first

    group_admin_role = Role
      .where({
        account_id: account.id,
        user_id: user.id,
        name: 'group_admin'
      })
      .first

    unless broker_role
      broker_role = Role.create \
        account_id: account.id,
        user_id: user.id,
        name: 'broker'
    end

    unless group_admin_role
      group_admin_role = Role.create \
        account_id: account.id,
        user_id: user.id,
        name: 'group_admin'
    end
  end
end
