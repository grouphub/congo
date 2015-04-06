class Token < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :account

  before_save :ensure_unique_id

  def ensure_unique_id
    self.unique_id = ThirtySix.generate
  end
end

