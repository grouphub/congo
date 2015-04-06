class Invitation < ActiveRecord::Base
  acts_as_paranoid

  has_one :role

  belongs_to :account

  before_save :add_uuid

  def add_uuid
    self.uuid = ThirtySix.generate
  end
end

