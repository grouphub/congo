require "#{Rails.root}/lib/sluggerizer"

class Account < ActiveRecord::Base
  include Sluggable
  include Propertied

  has_many :roles
  has_many :applications
  has_many :carrier_accounts

  PLAN_NAMES = %[free basic standard premier admin]

  def needs_to_pay?
    last_payment = Payment
      .where(account_id: self.id)
      .order('created_at DESC')
      .first
    current_time = Time.now
    created_at = nil

    if last_payment
      created_at = last_payment.created_at
    else
      created_at = self.created_at
    end

    created_at_month = created_at.month
    created_at_day = (created_at.day > 28) ? 28 : created_at.day

    current_time.month > created_at_month &&
      current_time.day >= created_at_day
  end

  def enabled_features
    Feature.all.to_a.select { |feature|
      feature.enabled_for_all? || feature.account_ids.include?(self.id)
    }
  end
end

