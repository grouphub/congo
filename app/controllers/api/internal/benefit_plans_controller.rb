class Api::Internal::BenefitPlansController < ApplicationController
  protect_from_forgery

  before_filter :ensure_user!
  before_filter :ensure_account!
  before_filter :ensure_broker_or_group_admin!, only: [:create, :update, :destroy]

  def index
    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first
    role_slug = params[:role_id]
    benefit_plans = nil

    if role_slug == 'group_admin' || role_slug == 'broker'
      benefit_plans = BenefitPlan.where('account_id IS NULL or account_id = ?', current_account.id)
    else
      benefit_plans = BenefitPlan.where('is_enabled = TRUE and (account_id IS NULL or account_id = ?)', current_account.id)
    end

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

  # Render methods

  def render_benefit_plan(benefit_plan)
    # NOTE: Carrier account may be nil if it was deleted by the user.
    carrier_account = benefit_plan.carrier_account
    account = benefit_plan.account
    carrier = benefit_plan.carrier
    account_benefit_plan = benefit_plan.account_benefit_plan
    attachments = benefit_plan.attachments

    benefit_plan.as_json.merge({
      'carrier' => carrier,
      'account' => account,
      'carrier_account' => carrier_account,
      'account_benefit_plan' => account_benefit_plan,
      'attachments' => attachments
    })
  end
end

