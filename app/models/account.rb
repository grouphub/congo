require "#{Rails.root}/lib/sluggerizer"

class Account < ActiveRecord::Base
  include Sluggable

  has_many :roles
  has_many :applications
  has_many :account_carriers

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

    current_time.month > created_at.month &&
      current_time.day >= created_at.day
  end

  def simple_hash
    {
      id: self.id,
      name: self.name,
      slug: self.slug,
      tagline: self.tagline
    }
  end
end

