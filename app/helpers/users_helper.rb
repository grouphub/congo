module UsersHelper
  class AuthenticationException < StandardError
  end

  def signin!(email, password)
    user = User.find_by_email(email)

    raise AuthenticationException unless user
    raise AuthenticationException unless user.password == password

    @current_user = user
    session[:current_user_id] = user.id

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
    raise AuthenticationException unless current_user
  end

  def authenticate_admin!
    raise AuthenticationException unless admin?
  end

  # Make sure the user is totally signed up
  def ensure_signed_up!
    # current_user
  end

  # Render methods

  def render_user(user)
    return nil unless user

    accounts = user
      .roles
      .includes(:account)
      .map { |role|
        role.account.as_json.merge({
          'role' => role,
          'enabled_features' => role.account.enabled_features.map(&:name)
        })
      }

    user
      .as_json({
        except: [:encrypted_password]
      })
      .merge({
        'is_admin' => user.admin?,
        'accounts' => accounts,
        'message_count' => user.message_count,
        'notification_count' => user.notification_count
      })
  end
end

