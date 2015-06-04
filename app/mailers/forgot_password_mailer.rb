class ForgotPasswordMailer < ActionMailer::Base
  default from: 'info@grouphub.io'

  def forgot_password_email(user_id, protocol, host)
    user = User.find(user_id)

    @email = user.email
    @url = "#{protocol}#{host}/users/#{user.id}/reset_password/#{user.password_token}"
    @logo_url = "#{protocol}#{host}/logo.png"

    mail(to: @email, subject: 'Reset your password')
  end
end

