class Api::V1::BenefitPlansController < ApplicationController
  def index
    respond_to do |format|
      format.json {
        render json: {
          benefit_plans: BenefitPlan.all.map { |benefit_plan|
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
    account_carrier_id = params[:account_carrier_id]
    account_carrier = AccountCarrier.where(id: account_carrier_id, account_id: account.id).first
    properties = params[:properties]

    unless name
      # TODO: Handle this
    end

    unless account
      # TODO: Handle this
    end

    unless account_carrier
      # TODO: Handle this
    end

    benefit_plan = BenefitPlan.create! \
      name: name,
      account_id: account.id,
      account_carrier_id: account_carrier.id,
      properties: properties

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
    benefit_plan = BenefitPlan.where(id: params[:id]).first

    respond_to do |format|
      format.json {
        render json: {
          benefit_plan: render_benefit_plan(benefit_plan)
        }
      }
    end
  end

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
    account_carrier = benefit_plan.account_carrier

    benefit_plan.as_json.merge({
      'account_carrier' => account_carrier.as_json.merge({
        'account' => account_carrier.account,
        'carrier' => account_carrier.carrier
      })
    })
  end
end

