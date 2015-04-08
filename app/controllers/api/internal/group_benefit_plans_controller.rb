class Api::Internal::GroupBenefitPlansController < ApplicationController
  protect_from_forgery

  before_filter :ensure_user!
  before_filter :ensure_account!
  before_filter :ensure_broker_or_group_admin!

  def create
    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first
    group_slug = params[:group_id]
    group = Group.where(slug: group_slug).first
    benefit_plan_id = params[:benefit_plan_id]
    properties = params[:properties]

    group_benefit_plan = GroupBenefitPlan.create! \
      account_id: account.id,
      group_id: group.id,
      benefit_plan_id: benefit_plan_id,
      properties: properties

    respond_to do |format|
      format.json {
        render json: {
          group_benefit_plan: group_benefit_plan
        }
      }
    end
  end

  def destroy
    account_slug = params[:account_id]
    group_slug = params[:group_id]
    group = Group.where(slug: group_slug).first
    benefit_plan_id = params[:benefit_plan_id].to_i

    group_benefit_plans = GroupBenefitPlan
      .where(group_id: group.id, benefit_plan_id: benefit_plan_id)

    group_benefit_plans.destroy_all

    respond_to do |format|
      format.json {
        render json: {
          group_benefit_plan: nil
        }
      }
    end
  end
end

