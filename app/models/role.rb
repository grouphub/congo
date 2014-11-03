class Role < ActiveRecord::Base
  belongs_to :account
  belongs_to :user

  before_save :add_english_name

  def add_english_name
    self.english_name = self.name.split('_').map(&:capitalize).join(' ')
  end

  def simple_hash
    {
      id: self.id,
      account_id: self.account_id,
      user_id: self.user_id,
      name: self.name,
      english_name: self.english_name
    }
  end
end

