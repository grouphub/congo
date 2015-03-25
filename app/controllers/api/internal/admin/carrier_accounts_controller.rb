class Api::Internal::Admin::CarrierAccountsController < ApplicationController
  protect_from_forgery

  before_filter :ensure_admin!

  def index
    carrier_accounts = CarrierAccount.where('account_id IS NULL')

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
    # TODO: Fill this in
  end

  def show
    id = params[:id]
    carrier_account = CarrierAccount.where('account_id is NULL and id = ?', id).first

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
    # TODO: Fill this in
  end

  def destroy
    # TODO: Fill this in
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

