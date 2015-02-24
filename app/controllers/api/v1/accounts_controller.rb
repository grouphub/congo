class Api::V1::AccountsController < ApplicationController
  include ApplicationHelper

  def update
    # TODO: Bail if not signed in

    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first

    # TODO: Bail if not valid account
    # TODO: Make sure name is unique

    name = params[:name]
    tagline = params[:tagline]
    tax_id = params[:tax_id]
    first_name = params[:first_name]
    last_name = params[:last_name]
    phone = params[:phone]
    plan_name = params[:plan_name]
    properties = account.properties || {}

    if name.present?
      account.name = name
      properties['name'] = name
    end

    if tagline
      account.tagline = tagline
      properties['tagline'] = tagline
    end

    if tax_id
      properties['tax_id'] = tax_id
    end

    if first_name
      properties['first_name'] = first_name
    end

    if last_name
      properties['last_name'] = last_name
    end

    # TODO : Make sure plan name is valid
    if phone
      properties['phone'] = phone
    end

    if plan_name
      account.plan_name = plan_name
    end

    account.properties = properties
    account.save!

    respond_to do |format|
      format.json {
        render json: {
          user: render_user(current_user)
        }
      }
    end
  end
end

