class Api::Internal::NotificationsController < ApplicationController
  before_filter :ensure_user!
  before_filter :ensure_account!

  protect_from_forgery

  def index
    since = params[:since] ? Time.parse(params[:since]) : nil
    role_name = params[:role_id]
    role = Role
      .where(account_id: current_account.id)
      .where(name: role_name)
      .where(user_id: current_user.id)
      .first
    notifications = Notification
      .where(account_id: current_account.id)
      .where(role_id: role.id)

    if since
      notifications.where('created_at > ?', since)
    end

    respond_to do |format|
      format.json {
        render json: {
          notifications: notifications
        }
      }
    end
  end
end

