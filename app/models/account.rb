require "#{Rails.root}/lib/sluggerizer"

class Account < ActiveRecord::Base
  include Sluggable
  include Propertied

  acts_as_paranoid

  has_many :groups
  has_many :roles
  has_many :applications
  has_many :application_statuses
  has_many :carriers
  has_many :carrier_accounts
  has_many :benefit_plans
  has_many :group_benefit_plans
  has_many :account_benefit_plans
  has_many :tokens
  has_many :payments
  has_many :invoices
  has_many :invitations
  has_many :memberships
  has_many :attachments
  has_many :notifications

  before_save :set_billing_start_and_day

  # NOTE: Slug will be nil for new accounts.
  validates_uniqueness_of :slug, allow_nil: true

  # Demo period is in days.
  DEMO_PERIOD = 30
  PLAN_NAMES = %[basic standard premier admin]

  # TODO: Move to a background job
  def nuke!
    self.account_benefit_plans.destroy_all
    self.group_benefit_plans.destroy_all
    self.attachments.destroy_all
    self.applications.destroy_all
    self.application_statuses.destroy_all
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

  def eviscerate!
    self.account_benefit_plans.each(&:really_destroy!)
    self.group_benefit_plans.each(&:really_destroy!)
    self.attachments.each(&:really_destroy!)
    self.applications.each(&:really_destroy!)
    self.application_statuses.each(&:really_destroy!)
    self.benefit_plans.each(&:really_destroy!)
    self.memberships.each(&:really_destroy!)
    self.carrier_accounts.each(&:really_destroy!)
    self.groups.each(&:really_destroy!)
    self.roles.each(&:really_destroy!)
    self.tokens.each(&:really_destroy!)
    self.carriers.each(&:really_destroy!)
    self.invitations.each(&:really_destroy!)

    # TODO: Do we actually want to destroy payments?
    self.payments.each(&:really_destroy!)

    self.really_destroy!
  end

  def set_billing_start_and_day
    date = Date.today + DEMO_PERIOD

    self.billing_start ||= date
    self.billing_day ||= [self.billing_start.day, 28].min
  end

  def needs_invoicing?
    return false if self.plan_name == 'admin'

    last_invoice = Invoice
      .where(account_id: self.id)
      .order('created_at DESC')
      .first
    current_time = Date.today
    last_invoice_at = last_invoice ? last_invoice.created_at : self.billing_start

    current_time.month > last_invoice_at.month &&
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

