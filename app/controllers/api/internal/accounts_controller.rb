class Api::Internal::AccountsController < Api::ApiController
  protect_from_forgery

  before_filter :ensure_user!
  before_filter :ensure_account!, except: [:create, :destroy]
  before_filter :ensure_broker!, except: [:create, :destroy]

  def create
    properties = params[:properties] || {}
    name = properties['name']
    tagline = properties['tagline']
    plan_name = properties['plan_name']

    # TODO: What if a customer wants to create a broker account?
    unless current_user.properties['is_broker']
      error_response('You must be a broker to create an account.')
      return
    end

    unless name.present?
      error_response('Name must be provided.')
      return
    end

    unless Account::PLAN_NAMES.include?(plan_name)
      error_response('Plan name must be valid.')
      return
    end

    account = Account.create! \
      name: name,
      tagline: tagline,
      plan_name: plan_name,
      properties: properties

    Role.create! \
      user_id: current_user.id,
      account_id: account.id,
      name: 'broker'

    respond_to do |format|
      format.json {
        render json: {
          user: render_user(current_user)
        }
      }
    end
  end

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

    if Account::PLAN_NAMES.include?(plan_name || '')
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
    account_slug = params[:id]
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

