class Role < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :account
  belongs_to :user
  belongs_to :invitation

  has_many :memberships

  before_save :add_english_name

  def add_english_name
    self.english_name = self.name.split('_').map(&:capitalize).join(' ')
  end

  def message_count
    return nil unless self.account && self.account.slug
    return nil unless self.user && self.user.full_name

    Digest::MD5.hexdigest(self.account.slug + ':' + self.user.full_name).to_i(16) % 30
  end

  def activity_count
    return nil unless self.account && self.account.slug
    return nil unless self.user && self.user.full_name

    Digest::MD5.hexdigest(self.account.slug + ':' + self.user.full_name + 'test').to_i(16) % 30
  end
end

