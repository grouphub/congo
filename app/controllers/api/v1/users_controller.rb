class Api::V1::UsersController < ApplicationController
  include ApplicationHelper

  def create
    name = params[:name]
    email = params[:email]
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    type = params[:type]
    email_token = params[:email_token]

    if password != password_confirmation
      # TODO: Handle this
    end

    user = User.create! \
      name: name,
      email: email,
      password: password,
      roles: [type]

    # User came in from an email and is therefore a customer
    if email_token
      membership = Membership.where(email_token: email_token).first
      membership.user_id = user.id
      membership.save!
    end

    respond_to do |format|
      format.json {
        render json: user.simple_hash
      }
    end
  end

  def signin
    name = params[:name]
    password = params[:password]

    begin
      user = signin! name, password

      respond_to do |format|
        format.json {
          render json: user.simple_hash
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

