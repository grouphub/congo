class MembershipMailer < ActionMailer::Base
  default from: "from@example.com"

  def confirmation_email(membership, request)
    email = membership.email
    email_token = membership.email_token
    group_name = membership.group.name

    @email = membership.email
    @group = membership.group.name
    @url = "#{request.protocol}#{request.host_with_port}/users/new_customer?email_token=#{email_token}"

    # TODO: Add account name
    # TODO: Finish laying out email
    # TODO: Finish routing for customer
    mail(to: email, subject: "You've been invited to join #{group_name}")
  end
end

