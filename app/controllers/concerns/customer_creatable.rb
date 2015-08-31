module CustomerCreatable
  extend ActiveSupport::Concern

  included do
    # Class methods here...
  end

  def attempt_to_create_customer!
    password    = params[:password]
    email_token = params[:email_token]

    return unless email_token

    membership = Membership.where(email_token: email_token).includes(:group).first
    user       = membership.user
    group      = membership.group
    role_name  = membership.role_name
    account_id = group.account_id

    user.update(password: password)

    unless membership
      # TODO: Handle this
    end

    role = Role
      .where({
        account_id: account_id,
        user_id: user.id,
        name: role_name
      })
      .first

    unless role
      membership.create_role \
        account_id: account_id,
        user_id: user.id,
        name: role_name
    end
  end

  def attempt_to_link_customer!(user)
    email_token = params[:email_token]

    return unless email_token

    email = params[:email]
    password = params[:password]
    email_token = params[:email_token]

    membership = Membership.where(email_token: email_token).includes(:group).first
    role_name = membership.role_name
    group = membership.group
    account_id = group.account_id

    role = Role
      .where({
        account_id: account_id,
        user_id: user.id,
        name: role_name
      })
      .first

    unless role
      role = Role.create! \
        account_id: account_id,
        user_id: user.id,
        name: role_name
    end

    membership.user_id = user.id
    membership.role_id = role.id
    membership.save!
  end
end
