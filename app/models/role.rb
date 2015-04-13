class Role < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :account
  belongs_to :user
  belongs_to :invitation

  has_many :memberships
  has_many :notifications

  before_save :add_english_name

  def add_english_name
    self.english_name = self.name.split('_').map(&:capitalize).join(' ')
  end

  # TODO: Update this
  def message_count
    0
  end

  def activity_count
    return nil unless self.account && self.account.slug

    Notification
      .where(account_id: self.account.id)
      .where(role_id: self.id)
      .where('read_at is NULL')
      .count
  end
end

