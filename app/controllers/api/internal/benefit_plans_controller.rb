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

  def create
    name = params[:name]
    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first
    carrier_account_id = params[:carrier_account_id]
    carrier_account = CarrierAccount.where(id: carrier_account_id, account_id: account.id).first
    properties = params[:properties]
    description_markdown = properties['description_markdown']
    description_html = properties['description_html']

    unless name
      # TODO: Test this
      error_response('Name must be provided.')
      return
    end

    unless account
      # TODO: Test this
      error_response('Could not find a matching account.')
      return
    end

    unless carrier_account
      # TODO: Test this
      error_response('Could not find a matching carrier account.')
      return
    end

    benefit_plan = BenefitPlan.create! \
      name: name,
      account_id: account.id,
      carrier_account_id: carrier_account.id,
      properties: properties,
      description_markdown: description_markdown,
      description_html: description_html

    respond_to do |format|
      format.json {
        render json: {
          benefit_plan: render_benefit_plan(benefit_plan)
        }
      }
    end
  end

  def update
    benefit_plan = BenefitPlan.find(params[:id])
    properties = params[:properties]

    unless benefit_plan
      # TODO: Test this
      error_response('Could not find a matching benefit plan.')
      return
    end

    # Only modify `is_enabled` if it is passed as a parameter.
    unless params[:is_enabled].nil?
      benefit_plan.update_attributes! \
        is_enabled: params[:is_enabled]
    end

    # Only modify `properties` if it is passed as a parameter.
    unless properties.nil?
      name = properties['name']
      description_markdown = properties['description_markdown']
      description_html = properties['description_html']
      carrier_account_id = properties['carrier_account_id'].to_i

      benefit_plan.update_attributes! \
        name: name,
        carrier_account_id: carrier_account_id,
        properties: properties,
        description_markdown: description_markdown,
        description_html: description_html
    end

    respond_to do |format|
      format.json {
        render json: {
          benefit_plan: render_benefit_plan(benefit_plan)
        }
      }
    end
  end

  def show
    id = params[:id]
    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first
    benefit_plan = BenefitPlan
      .where('account_id IS NULL OR account_id = ?', account.id)
      .where(id: params[:id])
      .first

    respond_to do |format|
      format.json {
        render json: {
          benefit_plan: render_benefit_plan(benefit_plan)
        }
      }
    end
  end

  # TODO: Scope benefit plan by account
  def destroy
    id = params[:id]

    benefit_plan = BenefitPlan.find(id).destroy

    respond_to do |format|
      format.json {
        render json: {
          benefit_plan: render_benefit_plan(benefit_plan)
        }
      }
    end
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

