class Api::V1::MembershipsController < ApplicationController
  def index
    account_id = params[:account_id]
    group_id = params[:group_id]
    memberships = Membership.where(group_id: group_id)

    respond_to do |format|
      format.json {
        render json: {
          memberships: memberships
        }
      }
    end
  end

  def create
    account_slug = params[:account_id]
    group_slug = params[:group_id]
    group = Group.where(slug: group_slug).first
    email = params[:membership][:email]

    membership = Membership.create! \
      group_id: group.id,
      email: email

    MembershipMailer.confirmation_email(membership, request).deliver

    respond_to do |format|
      format.json {
        render json: {
          membership: membership
        }
      }
    end
  end

  def destroy
    account_id = params[:account_id]
    group_id = params[:group_id]
    membership_id = params[:id]
    membership = Membership.where(id: membership_id).first

    membership.destroy!

    respond_to do |format|
      format.json {
        render json: {
          membership: membership
        }
      }
    end
  end

  def send_confirmation
    account_id = params[:account_id]
    group_id = params[:group_id]
    membership_id = params[:membership_id]
    membership = Membership.where(id: membership_id).first

    MembershipMailer.confirmation_email(membership, request).deliver

    respond_to do |format|
      format.json {
        render json: {
          membership: membership
        }
      }
    end
  end
end

