class NotificationMailer < ActionMailer::Base
  default from: 'info@grouphub.io'

  def notification_email(notification)
    account = notification.account
    role = notification.role
    user = role.user

    @notification = notification
    @email = user.email
    @url = "#{protocol}#{host}/#{account.slug}/#{role.name}/notifications"

    mail(to: @email, subject: 'You received a notification')
  end
end

