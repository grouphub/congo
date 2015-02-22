class Feature < ActiveRecord::Base

  after_create :ensure_account_ids

  def ensure_account_ids
    self.account_ids ||= []
  end

  def account_ids=(list)
    self.account_id_data = list.to_json
  end

  def account_ids
    JSON.load(self.account_id_data)
  end

end

