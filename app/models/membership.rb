class Membership < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user
  belongs_to :role
  belongs_to :group
  belongs_to :account

  has_many :applications
  has_many :invoices

  before_save :create_email_token

  # Grace period is in days.
  GRACE_PERIOD = 2

  def create_email_token
    self.email_token ||= ThirtySix.generate
  end

  # If a membership is associated with a user, use the user's email instead,
  # since the user can change their email address.
  def email
    self.user.try(:email) || self.original_email
  end

  # Use this if you really want the original email used to sign up for the
  # membership
  def original_email
    read_attribute(:email)
  end

  def employee?
    self.role.try(:name) == 'employee' || self.role_name == 'employee'
  end

  # Membership is invoiceable if a user has been invited and it is outside the
  # grace period.
  def invoiceable?
    has_user_id = self.user.present?
    grace_date = self.created_at.to_date + GRACE_PERIOD

    self.employee? && has_user_id && grace_date < Date.today
  end
end

