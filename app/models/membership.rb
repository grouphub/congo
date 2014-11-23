class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  belongs_to :group

  has_many :applications

  before_save :create_email_token

  def create_email_token
    self.email_token = SecureRandom.uuid if self.email_token.nil?
  end
end

