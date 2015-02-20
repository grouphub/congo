require "#{Rails.root}/lib/sluggerizer"

class Account < ActiveRecord::Base
  include Sluggable
  include Propertied

  has_many :roles
  has_many :applications
  has_many :carrier_accounts

  before_save :set_billing_start_and_day

  DEMO_PERIOD = 30
  PLAN_NAMES = %[free basic standard premier admin]

  def set_billing_start_and_day
    date = Date.today + DEMO_PERIOD

    self.billing_start ||= date
    self.billing_day ||= [self.billing_start.day, 28].min
  end

  def needs_to_pay?
    return false if self.plan_name == 'free'
    return false if self.plan_name == 'admin'

    last_payment = Payment
      .where(account_id: self.id)
      .order('created_at DESC')
      .first
    current_time = Date.today
    created_at = last_payment ? last_payment.created_at : self.billing_start

    current_time.month > created_at.month &&
      current_time.day >= self.billing_day
  end
end

