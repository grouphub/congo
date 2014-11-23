module CustomerCreatable
  extend ActiveSupport::Concern

  included do
    # Class methods here...
  end

  def attempt_to_create_customer!(params)
    email_token = params[:email_token]

    return unless email_token

    first_name = params[:first_name]
    last_name = params[:last_name]
    email = params[:email]
    password = params[:password]

    user = User.create! \
      first_name: first_name,
      last_name: last_name,
      email: email,
      password: password

    membership = Membership.where(email_token: email_token).includes(:group).first
    group = membership.group
    account_id = group.account_id

    unless membership
      # TODO: Handle this
    end

    membership.user_id = user.id
    membership.save!

    role = Role
      .where({
        account_id: account_id,
        user_id: user.id,
        name: 'customer'
      })
      .first

    unless role
      Role.create! \
        account_id: account_id,
        user_id: user.id,
        name: 'customer'
    end
  end

  def attempt_to_link_customer!(params, user)
    email_token = params[:email_token]

    return unless email_token

    email = params[:email]
    password = params[:password]
    email_token = params[:email_token]

    membership = Membership.where(email_token: email_token).includes(:group).first
    group = membership.group
    account_id = group.account_id

    membership.user_id = user.id
    membership.save!

    role = Role
      .where({
        account_id: account_id,
        user_id: user.id,
        name: 'customer'
      })
      .first

    unless role
      Role.create! \
        account_id: account_id,
        user_id: user.id,
        name: 'customer'
    end
  end
end
