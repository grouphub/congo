require "#{Rails.root}/lib/sluggerizer"

class Account < ActiveRecord::Base
  include Sluggable
  include Propertied

  acts_as_paranoid

  has_many :groups
  has_many :roles
  has_many :applications
  has_many :carriers
  has_many :carrier_accounts
  has_many :benefit_plans
  has_many :group_benefit_plans
  has_many :account_benefit_plans
  has_many :tokens
  has_many :payments
  has_many :invitations
  has_many :memberships
  has_many :attachments

  before_save :set_billing_start_and_day

  # NOTE: Slug will be nil for new accounts.
  validates_uniqueness_of :slug, allow_nil: true

  DEMO_PERIOD = 30
  PLAN_NAMES = %[basic standard premier admin]

  # TODO: Move to a background job
  def nuke!
    self.account_benefit_plans.destroy_all
    self.group_benefit_plans.destroy_all
    self.attachments.destroy_all
    self.applications.destroy_all
    self.benefit_plans.destroy_all
    self.memberships.destroy_all
    self.carrier_accounts.destroy_all
    self.groups.destroy_all
    self.roles.destroy_all
    self.tokens.destroy_all
    self.carriers.destroy_all
    self.invitations.destroy_all

    # TODO: Do we actually want to destroy payments?
    self.payments.destroy_all

    self.destroy!
  end

  def set_billing_start_and_day
    date = Date.today + DEMO_PERIOD

    self.billing_start ||= date
    self.billing_day ||= [self.billing_start.day, 28].min
  end

  def needs_to_pay?
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

