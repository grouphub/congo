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
      .uniq(&:id)

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
    selected_by_id = params[:declined_by_id]
    declined_by_id = params[:declined_by_id]
    properties = params[:properties]

    application = Application.create! \
      account_id: account.id,
      benefit_plan_id: benefit_plan.id,
      membership_id: membership.id,
      selected_by_id: selected_by_id,
      selected_on: (selected_by_id ? DateTime.now : nil),
      declined_by_id: declined_by_id,
      declined_on: (declined_by_id ? DateTime.now : nil),
      properties: properties

    respond_to do |format|
      format.json {
        render json: {
          application: render_application(application)
        }
      }
    end
  end

  def show
    application = Application.find(params[:id].to_i)

    respond_to do |format|
      format.json {
        render json: {
          application: render_application(application)
        }
      }
    end
  end

  # NOTE: Only supports setting approved_by or submitted_by
  # TODO: Finish this
  # TODO: Optimize this
  def update
    application = Application.find(params[:id])
    benefit_plan_id = params[:benefit_plan_id]
    declined_by_id = params[:declined_by_id]
    applied_by_id = params[:applied_by_id]
    approved_by_id = params[:approved_by_id]
    submitted_by_id = params[:submitted_by_id]
    properties = params[:properties]

    if benefit_plan_id
      application.update_attribute(:benefit_plan_id, benefit_plan_id)
    end

    if declined_by_id
      application.update_attributes \
        declined_by_id: declined_by_id,
        declined_on: DateTime.now
    end

    if applied_by_id
      application.update_attributes \
        applied_by_id: applied_by_id,
        applied_on: DateTime.now
    end

    if approved_by_id
      application.update_attributes \
        approved_by_id: approved_by_id,
        approved_on: DateTime.now
    end

    if submitted_by_id
      application.update_attributes \
        submitted_by_id: submitted_by_id,
        submitted_on: DateTime.now
    end

    if properties
      application.update_attribute(:properties, properties)
    end

    respond_to do |format|
      format.json {
        render json: {
          application: render_application(application)
        }
      }
    end
  end

  def destroy
    application = Application.find(params[:id])

    application.destroy!

    respond_to do |format|
      format.json {
        render json: {
          application: {}
        }
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
      }),
      'state' => application.state,
      'human_state' => application.state.titleize,
      'state_label' => application.state_label
    })
  end
end

