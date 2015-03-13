class Api::Internal::MembershipsController < ApplicationController
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

  def create
    group_slug = params[:group_id]
    group = Group.where(slug: group_slug).first
    email = params[:membership][:email]
    role_name = params[:role_name]

    membership = Membership.create! \
      group_id: group.id,
      email: email,
      role_name: role_name

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

  def send_confirmation
    membership_id = params[:membership_id]
    membership = Membership.where(id: membership_id).first

    MembershipMailer.confirmation_email(membership, request).deliver

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

      MembershipMailer.confirmation_email(membership, request).deliver
    end

    respond_to do |format|
      format.json {
        render json: {
          membership: render_memberships(memberships)
        }
      }
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

