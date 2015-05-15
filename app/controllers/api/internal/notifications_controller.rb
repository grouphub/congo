class Api::Internal::NotificationsController < Api::ApiController
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

  def update
    id = params[:id]
    read_at = params[:read_at] ? Time.parse(params[:read_at]) : nil
    unread_at = params[:unread_at] ? Time.parse(params[:unread_at]) : nil
    role_name = params[:role_id]
    role = Role
      .where(account_id: current_account.id)
      .where(name: role_name)
      .where(user_id: current_user.id)
      .first
    notification = Notification
      .where(account_id: current_account.id)
      .where(role_id: role.id)
      .where(id: id.to_i)
      .first

    if read_at
      notification.update_attributes! \
        read_at: read_at
    end

    if unread_at
      notification.update_attributes! \
        read_at: nil
    end

    respond_to do |format|
      format.json {
        render json: {
          notification: notification.as_json
        }
      }
    end
  end

  def destroy
    id = params[:id]
    role_name = params[:role_id]
    role = Role
      .where(account_id: current_account.id)
      .where(name: role_name)
      .where(user_id: current_user.id)
      .first
    notification = Notification
      .where(account_id: current_account.id)
      .where(role_id: role.id)
      .where(id: id.to_i)
      .first

    notification.destroy!

    respond_to do |format|
      format.json {
        render json: {
          notification: notification.as_json
        }
      }
    end
  end

  def count
    role_name = params[:role_id]
    role = Role
      .where(account_id: current_account.id)
      .where(name: role_name)
      .where(user_id: current_user.id)
      .first

    respond_to do |format|
      format.json {
        render json: {
          count: role.try(:activity_count)
        }
      }
    end
  end

  def mark_all_as_read
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

    notifications.update_all \
      read_at: Time.now

    respond_to do |format|
      format.json {
        render json: {}
      }
    end
  end
end

