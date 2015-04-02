class Api::Internal::CarriersController < ApplicationController
  protect_from_forgery

  before_filter :ensure_user!
  before_filter :ensure_account!
  before_filter :ensure_broker!, only: [:create, :destroy]

  def index
    carriers = Carrier.where('account_id IS NULL OR account_id = ?', current_account.id)

    respond_to do |format|
      format.json {
        render json: {
          carriers: carriers.map { |carrier|
            render_carrier(carrier)
          }
        }
      }
    end
  end

  # Render methods

  def render_carrier(carrier)
    # TODO: Add this everywhere
    raise 'Carrier should not be nil.' if carrier.nil?

    carrier.as_json.merge({
      account: carrier.account,
      carrier_account: carrier.carrier_accounts.where(account_id: current_account.id).first
    })
  end
end

