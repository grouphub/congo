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
          applications: applications.map(&:simple_hash)
        }
      }
    end
  end

  def create
    account_slug = params[:account_id]
    group_slug = params[:group_slug]
    product_id = params[:product_id]
    account = Account.where(slug: account_slug).first
    group = Group.where(slug: group_slug).first
    product = Product.where(id: product_id).first
    membership = Membership.where(group_id: group.id, user_id: current_user.id).first

    application = Application.create! \
      account_id: account.id,
      product_id: product.id,
      membership_id: membership.id

    respond_to do |format|
      format.json {
        render json: application
      }
    end
  end
end

