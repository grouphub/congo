# TODO: Secure this controller
class Api::Internal::UsersController < ApplicationController
  include ApplicationHelper
  include UsersHelper
  include CustomerCreatable
  include BrokerCreatable

  protect_from_forgery

  def create
    first_name = params[:first_name]
    last_name = params[:last_name]
    email = params[:email]
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    type = params[:type]
    email_token = params[:email_token]

    if password != password_confirmation
      # TODO: Test this
      error_response('Password and confirmation must match.')
      return
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
    is_invite = params[:is_invite]
    invite_code = params[:invite_code]
    user_properties = params[:user_properties] || {}
    account_properties = params[:account_properties] || {}
    account_name = account_properties['name']
    account_tagline = account_properties['tagline']
    role = user.roles.first
    account = nil

    plan_name = params[:plan_name]

    if is_invite
      unless invite_code
        error_response('An invite code must be provided or a plan must be picked.')
        return
      end

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
      account.save!
    end

    if account_name
      account = user.roles.first.account
      account.name ||= account_name
      account.tagline ||= account_tagline
      account.save!
    end

    if account_properties
      account = user.roles.first.account
      account.properties = (account.properties || {}).merge(account_properties)
      account.name ||= account.properties['name']
      account.tagline ||= account.properties['tagline']
      account.save!
    end

    user.save!

    if account
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

