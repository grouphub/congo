class Role < ActiveRecord::Base
  belongs_to :account
  belongs_to :user

  before_save :add_english_name

  def add_english_name
    self.english_name = self.name.split('_').map(&:capitalize).join(' ')
  end
end

