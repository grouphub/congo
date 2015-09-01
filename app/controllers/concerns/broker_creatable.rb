module BrokerCreatable
  extend ActiveSupport::Concern

  included do
    # Class methods here...
  end

  def attempt_to_create_broker!
    email_token = params[:email_token]
    type = params[:type]

    return if email_token
    return if type != 'broker'

    first_name = params[:first_name]
    last_name = params[:last_name]
    email = params[:email]
    password = params[:password]

    user = User.create! \
      first_name: first_name,
      last_name: last_name,
      email: email,
      password: password,
      properties: {
        is_broker: true
      }

    account = Account.create!

    broker_role = Role
      .where({
        account_id: account.id,
        user_id: user.id,
        name: 'broker'
      })
      .first

    unless broker_role
      broker_role = Role.create \
        account_id: account.id,
        user_id: user.id,
        name: 'broker'
    end
  end
end
