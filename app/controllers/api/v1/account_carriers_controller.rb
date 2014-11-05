class Api::V1::AccountCarriersController < ApplicationController
  def index
    # TODO: Check for current user

    respond_to do |format|
      format.json {
        render json: {
          account_carriers: AccountCarrier.all.map { |account_carrier|
            render_account_carrier(account_carrier)
          }
        }
      }
    end
  end

  def create
    # TODO: Check for current user

    name = params[:name]
    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first
    carrier_slug = params[:carrier_slug]
    carrier = Carrier.where(slug: carrier_slug).first
    properties = params[:properties]

    unless name
      # TODO: Handle this
    end

    unless account
      # TODO: Handle this
    end

    unless carrier
      # TODO: Handle this
    end

    account_carrier = AccountCarrier.create! \
      account_id: account.id,
      carrier_id: carrier.id,
      properties: properties,
      name: name

    respond_to do |format|
      format.json {
        render json: {
          account_carrier: render_account_carrier(account_carrier)
        }
      }
    end
  end

  def show
    id = params[:id]
    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first
    account_carrier = AccountCarrier.where(account_id: account.id, id: id).first

    unless account_carrier
      # TODO: Handle this
    end

    respond_to do |format|
      format.json {
        render json: {
          account_carrier: render_account_carrier(account_carrier)
        }
      }
    end
  end

  def destroy
    id = params[:id]
    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first
    account_carrier = AccountCarrier.where(account_id: account.id, id: id).first

    unless account_carrier
      # TODO: Handle this
    end

    account_carrier.destroy!

    respond_to do |format|
      format.json {
        render json: {}
      }
    end
  end

  # Render methods

  def render_account_carrier(account_carrier)
    account_carrier.as_json.merge({
      account: account_carrier.account,
      carrier: account_carrier.carrier
    })
  end
end

