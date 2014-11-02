module ApplicationHelper
  class AuthenticationException < StandardError
  end

  def signin!(email, password)
    user = User.find_by_email(email)

    if user && user.password == password
      @current_user = user
      session[:current_user_id] = user.id
    else
      raise AuthenticationException
    end

    user
  end

  def signout!
    @current_user = nil
    session[:current_user_id] = nil
  end

  def admin?
    current_user && current_user.admin?
  end

  def current_user
    @current_user ||= User.where(id: session[:current_user_id]).first
  end

  def authenticate!
    unless current_user
      raise AuthenticationException
    end
  end

  def authenticate_admin!
    unless admin?
      raise AuthenticationException
    end
  end
end

