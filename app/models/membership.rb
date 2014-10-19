class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  before_save :create_email_token

  def create_email_token
    self.email_token = SecureRandom.uuid if self.email_token.nil?
  end

  def simple_hash
    {
      id: self.id,
      email: self.email,
      email_token: self.email_token,
      user: self.user.try(:simple_hash)
    }
  end
end

