class Api::V1::UsersController < ApplicationController
  include UsersHelper

  def create
    first_name = params[:first_name]
    last_name = params[:last_name]
    email = params[:email]
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    type = params[:type]
    email_token = params[:email_token]

    if password != password_confirmation
      # TODO: Handle this
    end

    user = User.create! \
      first_name: first_name,
      last_name: last_name,
      email: email,
      password: password

    # User came in from an email and is therefore a customer
    if email_token
      membership = Membership.where(email_token: email_token).includes(:group).first
      group = membership.group
      account_id = group.account_id

      unless membership
        # TODO: Handle this
      end

      membership.user_id = user.id
      membership.save!

      Role.create! \
        account_id: account_id,
        user_id: user.id,
        name: 'customer'

    # User came from a manual signup and is a broker
    else
      account = Account.create!

      Role.create! \
        account_id: account.id,
        user_id: user.id,
        name: 'broker'

      Role.create! \
        account_id: account.id,
        user_id: user.id,
        name: 'group_admin'
    end

    signin! email, password

    respond_to do |format|
      format.json {
        render json: {
          user: render_user(user)
        }
      }
    end
  end

  def update
    id = params[:id]
    user = User.where(id: id).first
    account_id = params[:account_id]
    account_name = params[:account_name]
    account_tagline = params[:account_tagline]
    invite_code = params[:invite_code]

    plan_name = params[:plan_name]

    if invite_code
      invitation = Invitation.where(uuid: invite_code).first

      if !invitation
        error_response("#{invite_code} is not a valid invite code")
        return
      end

      user.invitation_id = invitation.id
    end

    # Bail if the plan name is not correct
    if plan_name && !Account::PLAN_NAMES.include?(plan_name)
      error_response("#{plan_name} is not a valid plan type")
      return
    end

    user_properties = (user.properties || {}).merge(params[:user_properties] || {})

    user.properties = user_properties
    user.save!

    if account_name
      account = Account.where(id: account_id).first
      account.name = account_name
      account.tagline = account_tagline
      account.plan_name = plan_name
      account.properties = (account.properties || {}).merge(params[:account_properties])
      account.save!
    end

    respond_to do |format|
      format.json {
        render json: {
          user: render_user(user)
        }
      }
    end
  end

  def show
    id = params[:id]
    user = User.find_by_id(id)

    respond_to do |format|
      format.json {
        render json: {
          user: render_user(user)
        }
      }
    end
  end

  def signin
    email = params[:email]
    password = params[:password]
    email_token = params[:email_token]

    begin
      user = signin! email, password

      if email_token
        membership = Membership.where(email_token: email_token).includes(:group).first
        group = membership.group
        account_id = group.account_id

        Role.create! \
          account_id: account_id,
          user_id: user.id,
          name: 'customer'
      end

      respond_to do |format|
        format.json {
          render json: {
            user: render_user(user)
          }
        }
      end
    rescue AuthenticationException => e
      render nothing: true, status: :unauthorized
    end
  end

  def signout
    signout!

    render nothing: true
  end
end

