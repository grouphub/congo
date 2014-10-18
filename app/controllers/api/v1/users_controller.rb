class Api::V1::UsersController < ApplicationController
  include ApplicationHelper

  def create
    name = params[:name]
    email = params[:email]
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    type = params[:type]

    if password != password_confirmation
      # TODO: Handle this
    end

    user = User.create! \
      name: name,
      email: email,
      password: password,
      roles: [type]

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

