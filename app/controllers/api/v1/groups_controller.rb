class Api::V1::GroupsController < ApplicationController
  include UsersHelper

  def index
    respond_to do |format|
      format.json {
        render json: {
          # TODO: Scope groups by account
          groups: Group.all.map { |group|
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

    unless name
      # TODO: Handle this
    end

    unless account
      # TODO: Handle this
    end

    group = Group.create! \
      name: name,
      account_id: account.id

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
      membership.as_json.merge({
        'user' => render_user(membership.user),
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
        sum += membership.applications
        sum
      }

    group.as_json.merge({
      'memberships' => memberships,
      'benefit_plans' => benefit_plans,
      'applications' => applications
    })
  end
end

