class Api::V1::CarrierAccountsController < ApplicationController
  def index
    # TODO: Check for current user

    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first
    carrier_accounts = CarrierAccount.where(account_id: account.id)

    respond_to do |format|
      format.json {
        render json: {
          carrier_accounts: carrier_accounts.map { |carrier_account|
            render_carrier_account(carrier_account)
          }
        }
      }
    end
  end

  def create
    # TODO: Check for current user

    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first
    properties = params[:properties]
    name = properties['name']
    carrier_slug = properties['carrier_name']
    carrier = Carrier.where(slug: carrier_slug).first

    binding.pry

    unless name
      # TODO: Handle this
    end

    unless account
      # TODO: Handle this
    end

    unless carrier
      # TODO: Handle this
    end

    carrier_account = CarrierAccount.create! \
      account_id: account.id,
      carrier_id: carrier.id,
      properties: properties,
      name: name

    respond_to do |format|
      format.json {
        render json: {
          carrier_account: render_carrier_account(carrier_account)
        }
      }
    end
  end

  def show
    id = params[:id]
    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first
    carrier_account = CarrierAccount.where(account_id: account.id, id: id).first

    unless carrier_account
      # TODO: Handle this
    end

    respond_to do |format|
      format.json {
        render json: {
          carrier_account: render_carrier_account(carrier_account)
        }
      }
    end
  end

  def destroy
    id = params[:id]
    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first
    carrier_account = CarrierAccount.where(account_id: account.id, id: id).first

    unless carrier_account
      # TODO: Handle this
    end

    carrier_account.destroy!

    respond_to do |format|
      format.json {
        render json: {}
      }
    end
  end

  # Render methods

  def render_carrier_account(carrier_account)
    # TODO: Add this everywhere
    raise 'Carrier account should not be nil.' if carrier_account.nil?

    carrier_account.as_json.merge({
      account: carrier_account.account,
      carrier: carrier_account.carrier
    })
  end
end

