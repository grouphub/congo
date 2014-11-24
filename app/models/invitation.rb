class Invitation < ActiveRecord::Base
  has_one :user

  before_save :add_uuid

  def add_uuid
    self.uuid = SecureRandom.uuid
  end
end

