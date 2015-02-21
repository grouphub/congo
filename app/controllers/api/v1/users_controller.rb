class Api::V1::UsersController < ApplicationController
  include UsersHelper
  include CustomerCreatable
  include BrokerCreatable

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

    # If user came in from an email then they are a customer.
    attempt_to_create_customer!

    # If user came from a manual signup, then they're a broker.
    attempt_to_create_broker!

    user = signin! email, password

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
    invite_code = params[:invite_code]
    user_properties = params[:user_properties] || {}
    account_properties = params[:account_properties] || {}
    account_name = account_properties['name']
    account_tagline = account_properties['tagline']
    account = user.roles.first.account

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

    user.properties = (user.properties || {}).merge(user_properties)

    if plan_name
      account = user.roles.first.account
      account.plan_name = plan_name
    end

    if account_name
      account = user.roles.first.account
      account.name = account_name
      account.tagline = account_tagline
    end

    if account_properties
      account.properties = (account.properties || {}).merge(account_properties)
    end

    user.save!
    account.save!

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

    binding.pry

    begin
      user = signin! email, password

      # If user came in from an email then they are a customer.
      attempt_to_link_customer!(user)

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

