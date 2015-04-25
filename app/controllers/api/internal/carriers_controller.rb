class Api::Internal::CarriersController < Api::ApiController
  protect_from_forgery

  before_filter :ensure_user!
  before_filter :ensure_account!
  before_filter :ensure_broker!, only: [:create, :destroy]

  def index
    only_activated = (params[:only_activated] == 'true')
    carriers = nil

    if only_activated
      carriers = CarrierAccount
        .where('account_id = ?', current_account.id)
        .includes(:carrier)
        .map(&:carrier)
    else
      carriers = Carrier.where('account_id IS NULL OR account_id = ?', current_account.id)
    end

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

  def show
    slug = params[:id]
    carrier = Carrier
      .where('account_id IS NULL OR account_id = ?', current_account.id)
      .where(slug: slug)
      .first

    unless carrier
      # TODO: Test this
      error_response('Could not find a matching carrier.')
      return
    end

    respond_to do |format|
      format.json {
        render json: {
          carrier: render_carrier(carrier)
        }
      }
    end
  end

  def create
    properties = params[:properties]
    carrier_account_properties = params[:carrier_account_properties]
    name = properties['name']

    unless name
      # TODO: Test this
      error_response('Name must be provided.')
      return
    end

    carrier = Carrier.create! \
      account_id: current_account.id,
      name: name,
      properties: properties

    carrier_account = CarrierAccount.create! \
      account_id: current_account.id,
      carrier_id: carrier.id,
      properties: carrier_account_properties

    respond_to do |format|
      format.json {
        render json: {
          carrier: render_carrier(carrier)
        }
      }
    end
  end

  def update
    carrier = Carrier
      .where('account_id IS NULL OR account_id = ?', current_account.id)
      .where(slug: params[:id])
      .first
    carrier_account = CarrierAccount.where(carrier_id: carrier.id, account_id: current_account.id).first
    properties = params[:properties]
    carrier_account_properties = params[:carrier_account_properties]
    name = properties['name']

    if carrier.account_id == current_account.id
      carrier.update_attributes! \
        name: name,
        properties: properties
    end

    carrier_account ||= CarrierAccount.create! \
      carrier_id: carrier.id,
      account_id: current_account.id

    carrier_account.update_attributes! \
      properties: carrier_account_properties

    respond_to do |format|
      format.json {
        render json: {
          carrier: render_carrier(carrier)
        }
      }
    end
  end

  def destroy
    carrier = Carrier
      .where('account_id IS NULL or account_id = ?', current_account.id)
      .where(slug: params[:id])
      .first
    carrier_account = CarrierAccount.where(carrier_id: carrier.id, account_id: current_account.id).first

    if carrier.account_id == current_account.id
      carrier.try(:destroy!)
    end

    carrier_account.try(:destroy!)

    respond_to do |format|
      format.json {
        render json: {
          carrier: render_carrier(carrier)
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

