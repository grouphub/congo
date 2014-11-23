class Api::V1::GroupsController < ApplicationController
  include UsersHelper

  def index
    role_name = params[:role_id]
    groups = nil

    # TODO: Verify user role
    if role_name == 'customer'
      groups = Membership
        .where(user_id: current_user.id)
        .includes(:group)
        .map(&:group)
        .select(&:is_enabled)
    else
      groups = Group.all
    end

    respond_to do |format|
      format.json {
        render json: {
          # TODO: Scope groups by account
          groups: groups.map { |group|
            render_group(group)
          }
        }
      }
    end
  end

  def create
    name = params[:name]
    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first
    properties = params[:properties]

    unless name
      # TODO: Handle this
    end

    unless account
      # TODO: Handle this
    end

    group = Group.create! \
      name: name,
      account_id: account.id,
      properties: properties

    respond_to do |format|
      format.json {
        render json: {
          group: render_group(group)
        }
      }
    end
  end

  def show
    slug = params[:id]
    group = Group.where(slug: slug).first

    respond_to do |format|
      format.json {
        render json: {
          group: render_group(group)
        }
      }
    end
  end

  def update
    group = Group.find(params[:id])

    unless params[:group]['is_enabled'].nil?
      group.update_attribute(:is_enabled, params[:is_enabled])
    end

    respond_to do |format|
      format.json {
        render json: {
          group: render_group(group)
        }
      }
    end
  end

  def destroy
    id = params[:id]

    group = Group.find(id).destroy

    respond_to do |format|
      format.json {
        render json: {
          group: render_group(group)
        }
      }
    end
  end

  # Render methods

  def render_group(group)
    memberships = group.memberships.map { |membership|
      user = membership.user ? render_user(membership.user) : nil

      membership.as_json.merge({
        'user' => user,
        'applications' => membership.applications
      })
    }

    benefit_plans = group
      .group_benefit_plans
      .includes(:benefit_plan)
      .map { |group_benefit_plan|
        group_benefit_plan.benefit_plan
      }

    applications = Membership
      .where(user_id: current_user.id)
      .includes(:applications)
      .inject([]) { |sum, membership|
      sum += membership.applications.map { |application|
          application.as_json.merge({
            'state' => application.state,
            'human_state' => application.state.titleize,
            'state_label' => application.state_label
          })
        }

        sum
      }

    group.as_json.merge({
      'memberships' => memberships,
      'benefit_plans' => benefit_plans,
      'applications' => applications
    })
  end
end

