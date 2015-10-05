class Api::Internal::GroupsController < Api::ApiController
  include UsersHelper

  protect_from_forgery

  before_filter :ensure_user!
  before_filter :ensure_account!
  before_filter :ensure_broker_or_group_admin!, only: [:create, :update, :destroy]

  def index
    groups = nil

    if current_role.name == 'customer'
      groups = Membership
        .where(user_id: current_user.id)
        .includes(:group)
        .map(&:group)
        .select(&:is_enabled)
        .select { |group| group.account_id == current_account.id }
    elsif current_role.name == 'group_admin'
      groups = Membership
        .where(user_id: current_user.id)
        .includes(:group)
        .includes(:role)
        .select { |membership| membership.role.name == 'group_admin' }
        .map(&:group)
        .select { |group| group.account_id == current_account.id }
    else
      groups = Group.where(account_id: current_account.id)
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
    description_markdown = properties['description_markdown']
    description_html = properties['description_html']

    unless name
      # TODO: Test this
      error_response('A name must be provided.')
      return
    end

    unless account
      # TODO: Test this
      error_response('A matching account could not be found.')
      return
    end

    group = Group.create! \
      name: name,
      account_id: account.id,
      properties: properties,
      description_markdown: description_markdown,
      description_html: description_html

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

  # TODO: Customers should only have limited access to this
  def update
    group = Group.where(slug: params[:id]).last

    unless group
      # TODO: Test this
      error_response('Could not find a matching group.')
      return
    end

    unless params[:group]['is_enabled'].nil?
      group.update_attributes!(is_enabled: params[:is_enabled])
    end

    properties = params[:properties]

    unless properties.nil?
      description_markdown = properties['description_markdown']
      description_html = properties['description_html']

      group.update_attributes! \
        name: properties['name'],
        properties: properties,
        description_markdown: description_markdown,
        description_html: description_html
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
        'slug' => membership.slug,
        'applications' => membership.applications.map { |application|
          application.as_json.merge({
            'state' => application.state,
            'human_state' => application.human_state,
            'state_label' => application.state_label,
            'plan_name' => application.plan_name
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
            'human_state' => application.human_state,
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
      'applications' => applications,
      'attachments' => group.attachments
    })
  end
end

