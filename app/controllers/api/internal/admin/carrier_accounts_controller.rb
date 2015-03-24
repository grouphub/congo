class Api::Internal::CarrierAccountsController < ApplicationController
  protect_from_forgery

  before_filter :ensure_admin!

  def index
    # TODO: Fill this in
  end

  def create
    # TODO: Fill this in
  end

  def show
    # TODO: Fill this in
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

