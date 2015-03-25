class Api::Internal::CarrierAccountsController < ApplicationController
  protect_from_forgery

  before_filter :ensure_user!
  before_filter :ensure_account!
  before_filter :ensure_broker!, only: [:create, :destroy]

  def index
    carrier_accounts = CarrierAccount.where('account_id IS NULL or account_id = ?', current_account.id)

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
    properties = params[:properties]
    name = properties['name']
    carrier_slug = properties['carrier_slug']
    carrier = Carrier.where(slug: carrier_slug).first

    unless name
      # TODO: Test this
      error_response('Name must be provided.')
      return
    end

    unless carrier
      # TODO: Test this
      error_response('Could not find a matching carrier.')
      return
    end

    carrier_account = CarrierAccount.create! \
      account_id: current_account.id,
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
    carrier_account = CarrierAccount.where(account_id: current_account.id, id: id).first

    unless carrier_account
      # TODO: Test this
      error_response('Could not find a matching carrier.')
      return
    end

    respond_to do |format|
      format.json {
        render json: {
          carrier_account: render_carrier_account(carrier_account)
        }
      }
    end
  end

  def update
    id = params[:id]
    properties = params[:properties]
    name = properties['name']
    carrier_account = CarrierAccount.where(account_id: current_account.id, id: id).first

    unless carrier_account
      # TODO: Test this
      error_response('Could not find a matching carrier.')
      return
    end

    carrier_account.update_attributes! \
      name: name,
      properties: properties

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
    carrier_account = CarrierAccount.where(account_id: current_account.id, id: id).first

    unless carrier_account
      # TODO: Test this
      error_response('Could not find a matching carrier.')
      return
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

