require "#{Rails.root}/lib/sluggerizer"

class Account < ActiveRecord::Base
  include Sluggable
  include Propertied

  has_many :groups
  has_many :roles
  has_many :applications
  has_many :carrier_accounts
  has_many :tokens

  before_save :set_billing_start_and_day

  # # TODO: Slug will be blank for new accounts, which means that this won't work
  # validates_uniqueness_of :slug

  DEMO_PERIOD = 30
  PLAN_NAMES = %[free basic standard premier admin]

  # TODO: Move to a background job
  def nuke!
    self.carrier_accounts
      .includes(benefit_plans: :attachments)
      .each { |carrier_account|
        carrier_account.benefit_plans.each { |benefit_plan|
          benefit_plan.attachments.destroy_all
        }

        carrier_account.benefit_plans.destroy_all
      }

    self.groups
      .includes(:group_benefit_plans, :attachments)
      .each { |group|
        group.group_benefit_plans.destroy_all
        group.attachments.destroy_all
      }

    self.roles
      .includes({ memberships: :applications }, :invitation)
      .each { |role|
        role.memberships.each { |membership|
          membership.applications.destroy_all
        }

        role.memberships.destroy_all
        role.invitation.try(:destroy!)
      }

    self.carrier_accounts.destroy_all
    self.groups.destroy_all
    self.tokens.destroy_all
    self.roles.destroy_all
    self.destroy!
  end

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

  def enabled_features
    @enabled_features ||= Feature.all.to_a.select { |feature|
      feature.enabled_for_all? || feature.account_slugs.include?(self.slug)
    }
  end

  def feature_enabled?(feature_name)
    self.enabled_features.any? { |feature|
      feature.name == feature_name
    }
  end
end

