class MembershipMailer < ActionMailer::Base
  default from: 'info@grouphub.io'

  def confirmation_email(membership_id, protocol, host)
    membership = Membership.find(membership_id)
    email = membership.email
    email_token = membership.email_token
    group_name = membership.group.name

    @email = membership.email
    @group = membership.group.name
    @group_domain = 'broker'
    @group_admin = 'GroupHub Admin'
    @url = "#{protocol}#{host}/users/new_customer?email_token=#{email_token}"

    # TODO: Add account name
    # TODO: Finish laying out email
    # TODO: Finish routing for customer
    mail(to: email, subject: "You've been invited to join #{group_name}")
  end
end

