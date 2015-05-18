class Membership < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user
  belongs_to :role
  belongs_to :group
  belongs_to :account

  has_many :applications

  before_save :create_email_token

  def create_email_token
    self.email_token = SecureRandom.uuid if self.email_token.nil?
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
end

