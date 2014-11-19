class Invitation < ActiveRecord::Base
  belongs_to :user

  before_save :add_uuid

  def add_uuid
    self.uuid = SecureRandom.uuid
  end
end

