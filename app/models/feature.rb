class Feature < ActiveRecord::Base
  acts_as_paranoid

  before_save :ensure_account_slugs

  def ensure_account_slugs
    self.account_slugs ||= []
  end

  def account_slugs=(list)
    self.account_slug_data = (list || []).join(', ')
  end

  def account_slugs
    (self.account_slug_data || '').split(', ')
  end
end

