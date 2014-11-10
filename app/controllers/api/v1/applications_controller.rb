class Api::V1::ApplicationsController < ApplicationController
  # TODO: Implement this
  def index
    applications = Membership
      .where(user_id: current_user.id)
      .joins(:applications)
      .inject([]) { |applications, membership|
        applications += membership.applications
        applications
      }

    respond_to do |format|
      format.json {
        # TODO: Needs optimizing
        render json: {
          applications: applications.map { |application|
            render_application(application)
          }
        }
      }
    end
  end

  def create
    account_slug = params[:account_id]
    group_slug = params[:group_slug]
    benefit_plan_id = params[:benefit_plan_id]
    account = Account.where(slug: account_slug).first
    group = Group.where(slug: group_slug).first
    benefit_plan = BenefitPlan.where(id: benefit_plan_id).first
    membership = Membership.where(group_id: group.id, user_id: current_user.id).first

    application = Application.create! \
      account_id: account.id,
      benefit_plan_id: benefit_plan.id,
      membership_id: membership.id,
      applied_by_id: current_user.id

    respond_to do |format|
      format.json {
        render json: render_application(application)
      }
    end
  end

  def show
    application = Application.find(params[:id].to_i)

    respond_to do |format|
      format.json {
        render json: render_application(application)
      }
    end
  end

  # NOTE: Only supports setting approved_by or submitted_by
  # TODO: Finish this
  def update
    application = Application.find(params[:id])
    application.update_attribute(:submitted_by_id, current_user.id)
    respond_to do |format|
      format.json {
        render json: render_application(application)
      }
    end
  end

  # Render methods

  def render_application(application)
    membership = application.membership

    application.as_json.merge({
      'benefit_plan' => application.benefit_plan,
      'membership' => membership.as_json.merge({
        'group' => membership.group,
        'applications' => membership.applications
      })
    })
  end
end

