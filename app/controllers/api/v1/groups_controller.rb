class Api::V1::GroupsController < ApplicationController
  protect_from_forgery

  include UsersHelper

  def index
    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first
    role_name = params[:role_id]
    groups = nil

    # TODO: Verify user role
    if role_name == 'customer'
      groups = Membership
        .where(user_id: current_user.id)
        .includes(:group)
        .map(&:group)
        .select(&:is_enabled)
        .select { |group| group.account_id == account.id }
    elsif role_name == 'group_admin'
      groups = Membership
        .where(user_id: current_user.id)
        .includes(:group)
        .includes(:role)
        .select { |membership| membership.role.name == 'group_admin' }
        .map(&:group)
        .select { |group| group.account_id == account.id }
    else
      groups = Group.where(account_id: account.id)
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
      role = membership.role

      membership.as_json.merge({
        'user' => user.as_json,
        'role' => role.as_json,
        'applications' => membership.applications.map { |application|
          application.as_json.merge({
            'state' => application.state,
            'human_state' => application.state.titleize,
            'state_label' => application.state_label
          })
        }
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

    customer_memberships = memberships.select { |membership|
      role = membership['role'] || {}

      # Customers who have been invited but not confirmed do not have a role,
      # so we must check the "role_name" on the membership instead.
      role['name'] == 'customer' || membership['role_name'] == 'customer'
    }

    group_admin_memberships = memberships.select { |membership|
      role = membership['role'] || {}

      # Customers who have been invited but not confirmed do not have a role,
      # so we must check the "role_name" on the membership instead.
      role['name'] == 'group_admin' || membership['role_name'] == 'group_admin'
    }

    group.as_json.merge({
      'memberships' => memberships,
      'customer_memberships' => customer_memberships,
      'group_admin_memberships' => group_admin_memberships,
      'benefit_plans' => benefit_plans,
      'applications' => applications
    })
  end
end

