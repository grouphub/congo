class Api::Internal::BenefitPlansController < Api::ApiController
  protect_from_forgery

  before_filter :ensure_user!
  before_filter :ensure_account!
  before_filter :ensure_broker_or_group_admin!, only: [:create, :update, :destroy]

  def index
    only_activated_carriers = (params[:only_activated_carriers] == 'true')
    only_activated = (params[:only_activated] == 'true')

    benefit_plans = BenefitPlan
      .where(
        %[
          (account_id IS NULL AND is_enabled = TRUE) OR
          (account_id = ?)
        ],
        current_account.id
      )

    # if current_role.name == 'group_admin' || current_role.name == 'broker'
    #   # For group admins and brokers, do not show admin-created benefit plans
    #   # which are not enabled.
    #   benefit_plans = BenefitPlan
    #     .where(
    #       %[
    #         (account_id IS NULL AND is_enabled = TRUE) OR
    #         (account_id = ?)
    #       ],
    #       current_account.id
    #     )
    # else
    #   # For customers
    #   benefit_plans = BenefitPlan
    #     .where('account_id = ? AND is_enabled = TRUE', current_account.id)
    # end

    if only_activated_carriers
      # Plans whose carrier has been activated, but which themselves may not
      # have been activated yet, for display on the carriers index page.
      carrier_accounts = CarrierAccount.where(
        %[
          (account_id IS NULL) OR
            (account_id = ?)
        ],
        current_account.id
      )

      benefit_plans = benefit_plans
        .where(
          %[
              (carrier_account_id IS NULL) OR
                (carrier_account_id IN (?))
          ],
          carrier_accounts.map(&:id)
        )

      # benefit_plans = benefit_plans
      #   .where('carrier_account_id IN (?)', carrier_accounts.map(&:id))
    elsif only_activated
      # Plans which have been activated and enabled, for display on the groups
      # show page.
      benefit_plans = benefit_plans
        .where('is_enabled = TRUE')
        .includes(:account_benefit_plans)
        .to_a
        .select { |benefit_plan|
          benefit_plan.account_benefit_plans.any? { |account_benefit_plan|
            account_benefit_plan.account_id == current_account.id
          }
        }
    end

    respond_to do |format|
      format.json {
        render json: {
          benefit_plans: benefit_plans.map { |benefit_plan|
            render_benefit_plan(benefit_plan)
          }
        }
      }
    end
  end

  def show
    benefit_plan = BenefitPlan
      .where('account_id IS NULL or account_id = ?', current_account.id)
      .where(slug: params[:id])
      .first

    respond_to do |format|
      format.json {
        render json: {
          benefit_plan: render_benefit_plan(benefit_plan)
        }
      }
    end
  end

  def create
    name = params[:name]
    carrier_id = params[:carrier_id]
    carrier = Carrier.where(id: carrier_id).first
    carrier_account = carrier.carrier_accounts.where(account_id: current_account.id).first
    properties = params[:properties]
    account_benefit_plan_properties = params[:account_benefit_plan_properties]
    description_markdown = properties['description_markdown']
    description_html = properties['description_html']

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

    benefit_plan = BenefitPlan.create! \
      name: name,
      account_id: current_account.id,
      carrier_id: carrier.id,
      properties: properties,
      description_markdown: description_markdown,
      description_html: description_html

    account_benefit_plan = AccountBenefitPlan.create! \
      account_id: current_account.id,
      carrier_id: carrier.id,
      carrier_account_id: carrier_account.try(:id),
      benefit_plan_id: benefit_plan.id,
      properties: account_benefit_plan_properties

    respond_to do |format|
      format.json {
        render json: {
          benefit_plan: render_benefit_plan(benefit_plan)
        }
      }
    end
  end

  def update
    benefit_plan = BenefitPlan
      .where('account_id IS NULL or account_id = ?', current_account.id)
      .where(slug: params[:id])
      .first
    account_benefit_plan = AccountBenefitPlan.where(benefit_plan_id: benefit_plan.id, account_id: current_account.id).first
    carrier = benefit_plan.carrier
    carrier_account = CarrierAccount.where(account_id: current_account.id, carrier_id: carrier.id).first
    properties = params[:properties]
    account_benefit_plan_properties = params[:account_benefit_plan_properties]

    if benefit_plan.account_id == current_account.id
      # Only modify `properties` if it is passed as a parameter.
      unless properties.nil?
        name = properties['name']
        description_markdown = properties['description_markdown']
        description_html = properties['description_html']

        benefit_plan.update_attributes! \
          name: name,
          properties: properties,
          description_markdown: description_markdown,
          description_html: description_html
      end
    end

    if account_benefit_plan
      # Only modify `is_enabled` if it is passed as a parameter.
      unless params[:is_enabled].nil?
        benefit_plan.update_attributes! \
          is_enabled: params[:is_enabled]
      end
    end

    account_benefit_plan ||= AccountBenefitPlan.create! \
      account_id: current_account.id,
      carrier_id: carrier.id,
      carrier_account_id: carrier_account.try(:id),
      benefit_plan_id: benefit_plan.id

    # Only modify `account_benefit_plan_properties` if it is passed as a parameter.
    unless account_benefit_plan_properties.nil?
      account_benefit_plan.update_attributes! \
        properties: account_benefit_plan_properties
    end

    respond_to do |format|
      format.json {
        render json: {
          benefit_plan: render_benefit_plan(benefit_plan)
        }
      }
    end
  end

  def destroy
    benefit_plan = BenefitPlan
      .where('account_id IS NULL or account_id = ?', current_account.id)
      .where(slug: params[:id])
      .first
    account_benefit_plan = AccountBenefitPlan.where(benefit_plan_id: benefit_plan.id, account_id: current_account.id).first

    if benefit_plan.account_id == current_account.id
      benefit_plan.try(:destroy!)
    end

    account_benefit_plan.try(:destroy!)

    respond_to do |format|
      format.json {
        render json: {
          benefit_plan: render_benefit_plan(benefit_plan)
        }
      }
    end
  end

  # Render methods

  def render_benefit_plan(benefit_plan)
    # NOTE: Carrier account may be nil if it was deleted by the user.
    carrier_account = benefit_plan.carrier_account
    account = benefit_plan.account
    carrier = benefit_plan.carrier
    account_benefit_plan = benefit_plan.account_benefit_plans
      .to_a
      .select { |account_benefit_plan|
        account_benefit_plan.account_id == current_account.id
      }
    attachments = benefit_plan.attachments

    benefit_plan.as_json.merge({
      'carrier' => carrier,
      'account' => account,
      'carrier_account' => carrier_account,
      'account_benefit_plan' => account_benefit_plan,
      'attachments' => attachments
    })
  end
end

