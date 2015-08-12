module GroupAdminCreatable
  extend ActiveSupport::Concern

  included do
    # Class methods here...
  end

  def attempt_to_create_group_admin!
  
    first_name = params[:first_name]
    last_name  = params[:last_name]
    email      = params[:email]
    password   = params[:password]
    type       = params[:type]

    return if type != 'groupadmin'

    user = User.create! \
      first_name: first_name,
      last_name: last_name,
      email: email,
      password: password,
      properties: {
        is_broker: false
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
        name: 'group_admin'
    end
  end
end
