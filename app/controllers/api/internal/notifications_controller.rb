class Api::Internal::NotificationsController < ApplicationController
  before_filter :ensure_user!
  before_filter :ensure_account!

  protect_from_forgery

  def index
    since = params[:since] ? Time.parse(params[:since]) : nil
    limit = params[:limit] ? params[:limit].to_i : nil
    before = params[:before] ? Time.parse(params[:before]) : nil
    role_name = params[:role_id]
    role = Role
      .where(account_id: current_account.id)
      .where(name: role_name)
      .where(user_id: current_user.id)
      .first
    notifications = Notification
      .where(account_id: current_account.id)
      .where(role_id: role.id)
      .order('created_at DESC')

    notifications = notifications.where('created_at > ?', since) if since
    notifications = notifications.where('created_at < ?', before) if before
    notifications = notifications.limit(limit) if limit

    respond_to do |format|
      format.json {
        render json: {
          notifications: notifications
        }
      }
    end
  end

  def count
    since = params[:since] ? Time.parse(params[:since]) : nil
    limit = params[:limit] ? params[:limit].to_i : nil
    before = params[:before] ? Time.parse(params[:before]) : nil
    role_name = params[:role_id]
    role = Role
      .where(account_id: current_account.id)
      .where(name: role_name)
      .where(user_id: current_user.id)
      .first

    respond_to do |format|
      format.json {
        render json: {
          count: role.activity_count
        }
      }
    end
  end
end

