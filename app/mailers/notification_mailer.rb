class NotificationMailer < ActionMailer::Base
  default from: 'info@grouphub.io'

  def notification_email(notification, protocol, host)
    account = notification.account
    role = notification.role
    user = role.user

    @notification = notification
    @email = user.email
    @url = "#{protocol}#{host}/#{account.slug}/#{role.name}/notifications"
    @logo_url = "#{protocol}#{host}/logo.png"

    mail(to: @email, subject: 'You received a notification')
  end
end

