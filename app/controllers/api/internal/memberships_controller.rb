class Api::Internal::MembershipsController < Api::ApiController
  protect_from_forgery

  before_filter :ensure_user!
  before_filter :ensure_account!
  before_filter :ensure_broker_or_group_admin!

  def index
    group_slug = params[:group_id]
    group = Group.where(slug: group_slug).first
    memberships = Membership.where(group_id: group.id)

    respond_to do |format|
      format.json {
        render json: {
          memberships: render_memberships(memberships)
        }
      }
    end
  end

  #TODO: tables need to be normalized; email
  #is repeated on Memberships and Users tables
  def create
    group_slug = params[:group_id]
    group = Group.where(slug: group_slug).first
    email = params[:membership][:email]
    role_name = params[:role_name]

    unless role_name == 'customer' || role_name == 'group_admin'
      error_response 'Role must be "customer" or "group_admin".'
      return
    end

    membership = Membership.create! \
      account_id: group.account_id,
      group_id: group.id,
      email: email,
      role_name: role_name

    if role_name == 'group_admin'
      MembershipMailer.confirmation_email(membership.id, request.protocol, request.host_with_port).deliver_later
    end

    respond_to do |format|
      format.json {
        render json: {
          membership: render_membership(membership)
        }
      }
    end
  end

  def destroy
    membership_id = params[:id]
    membership = Membership.where(id: membership_id).first

    membership.destroy!

    respond_to do |format|
      format.json {
        render json: {
          membership: render_membership(membership)
        }
      }
    end
  end

  def update
    membership = Membership.find(params[:id].to_i)
    email = params[:email]

    if email
      membership.update_attributes!(email: email)
    end

    respond_to do |format|
      format.json {
        render json: {
          membership: render_membership(membership)
        }
      }
    end
  end

  def send_confirmation
    membership_id = params[:membership_id]
    membership = Membership.where(id: membership_id).first

    MembershipMailer.confirmation_email(membership.id, request.protocol, request.host_with_port).deliver_later

    respond_to do |format|
      format.json {
        render json: {
          membership: render_membership(membership)
        }
      }
    end
  end

  def send_confirmation_to_all
    group_slug = params[:group_id]
    group = Group.where(slug: group_slug).first
    memberships = group.memberships

    memberships.each do |membership|
      next if membership.user

      MembershipMailer.confirmation_email(membership.id, request.protocol, request.host_with_port).deliver_later
    end

    respond_to do |format|
      format.json {
        render json: {
          membership: render_memberships(memberships)
        }
      }
    end
  end

  def download_employee_template
    send_file 'public/GroupHub_Employee_Template.csv', type: 'application/csv'
  end

  def create_employees_from_list

    #TODO: WIP - Move this into a library to
    #create users out of csv uploaded by brokers
    require 'csv'

    csv_file_rows = CSV.read(params[:employee_list_file].tempfile)

    csv_headers = csv_file_rows.slice!(0).map do |header|
      if header.include?('/')
        header.downcase.gsub('/', '_').gsub(' ', '_')
      elsif header.include?('-')
        header.downcase.gsub('-', '_').gsub(' ', '_')
      else
        header.downcase.gsub(' ', '_')
      end
    end

    csv_headers = csv_headers.map(&:to_sym)

    employees = []

    csv_file_rows.each do |employee_info|
      employees << Hash[csv_headers.zip employee_info]
    end

    group = Group.where(slug: params[:group_id]).first

    employees.each do |employee|
      Membership.create! \
        account_id: group.account_id,
        group_id: group.id,
        email: employee[:email],
        role_name: params[:role_name]
    end

    respond_to do |format|
      format.json { render json: {} }
    end
  end

  # Render methods

  def render_membership(membership)
    membership.as_json.merge({
      user: membership.user
    })
  end

  def render_memberships(memberships)
    memberships.map { |membership|
      membership.as_json.merge({
        user: membership.user
      })
    }
  end
end

