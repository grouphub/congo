class Api::V1::GroupBenefitPlansController < ApplicationController
  def create
    account_slug = params[:account_id]
    group_slug = params[:group_id]
    group = Group.where(slug: group_slug).first
    benefit_plan_id = params[:benefit_plan_id]

    group_benefit_plan = GroupBenefitPlan.create! \
      group_id: group.id,
      benefit_plan_id: benefit_plan_id

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
    benefit_plan_id = params[:benefit_plan_id]

    group_benefit_plans = GroupBenefitPlan
      .where(group_id: group.id, benfit_plan_id: benefit_plan_id)

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

