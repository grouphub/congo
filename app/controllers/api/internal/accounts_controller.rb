class Api::Internal::AccountsController < ApplicationController
  protect_from_forgery

  before_filter :ensure_user!
  before_filter :ensure_account!
  before_filter :ensure_broker!

  def update
    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first

    unless account
      error_response('Could not find a matching account.')
      return
    end

    properties = params[:properties]

    # TODO: Make sure name is unique

    name = properties['name']
    tagline = properties['tagline']
    tax_id = properties['tax_id']
    first_name = properties['first_name']
    last_name = properties['last_name']
    phone = properties['phone']
    plan_name = properties['plan_name']
    card_number = properties['card_number']
    month = properties['month']
    year = properties['year']
    cvc = properties['cvc']

    # Only change name if it is non-empty
    if name.present?
      account.name = name
    end

    if tagline
      account.tagline = tagline
    end

    if plan_name
      account.plan_name = properties['plan_name']
    end

    if card_number
      account.card_number = properties['card_number']
    end

    if month
      account.month = properties['month']
    end

    if year
      account.year = properties['year']
    end

    if cvc
      account.cvc = properties['cvc']
    end

    if Account::PLAN_NAMES.include?(plan_name)
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

  def destroy
    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first
    role = Role.where(account_id: account.id, user_id: current_user.id)

    unless role.present?
      error_response('Could not find a matching account.')
      return
    end

    account.nuke!

    respond_to do |format|
      format.json {
        render json: {
          user: render_user(current_user)
        }
      }
    end
  end
end

