class Api::Internal::Admin::BenefitPlansController < ApplicationController
  protect_from_forgery

  before_filter :ensure_admin!

  def index
    benefit_plans = BenefitPlan.where('account_id IS NULL')

    respond_to do |format|
      format.json {
        render json: {
          benefit_plans: benefit_plans.map { |benefit_plan|
            render_benefit_plan(benefit_plan)
          }
        }
      }
    end
  end

  def create
    # TODO: Fill this in
  end

  def update
    # TODO: Fill this in
  end

  def show
    # TODO: Fill this in
  end

  def update
    # TODO: Fill this in
  end

  # Render methods

  def render_benefit_plan(benefit_plan)
    # NOTE: Carrier account may be nil if it was deleted by the user.
    carrier_account = benefit_plan.carrier_account
    account = carrier_account.try(:account)
    carrier = carrier_account.try(:carrier)
    carrier_account_hash = carrier_account.try(:as_json) || {}

    benefit_plan.as_json.merge({
      'carrier_account' => carrier_account_hash.merge({
        'account' => account,
        'carrier' => carrier
      }),
      'attachments' => benefit_plan.attachments
    })
  end
end

