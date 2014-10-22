require "#{Rails.root}/lib/sluggerizer"

class Account < ActiveRecord::Base
  has_many :account_users
  has_many :applications

  before_save :add_slug

  def add_slug
    self.slug = Sluggerizer.sluggerize(self.name) if self.name
  end

  def once_a_month(&block)
    last_payment = Payment.where(account_id: self.id)
    current_time = Time.now
    created_at = nil

    if last_payment
      created_at = last_payment.created_at
    else
      created_at = self.created_at
    end

    if(
      current_time.month > created_at.month &&
      current_time.day >= created_at.day
    )
      block.call
    end
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

