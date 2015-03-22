class Api::Internal::ApplicationsController < ApplicationController
  protect_from_forgery

  before_filter :ensure_user!
  before_filter :ensure_account!

  def index
    applications = Membership
      .where(user_id: current_user.id)
      .joins(:applications)
      .inject([]) { |applications, membership|
        applications += membership.applications
        applications
      }
      .uniq(&:id)

    respond_to do |format|
      format.json {
        # TODO: Needs optimizing
        render json: {
          applications: applications.map { |application|
            render_application(application)
          }
        }
      }
    end
  end

  def create
    account_slug = params[:account_id]
    group_slug = params[:group_slug]
    benefit_plan_id = params[:benefit_plan_id]
    account = Account.where(slug: account_slug).first
    group = Group.where(slug: group_slug).first
    benefit_plan = BenefitPlan.where(id: benefit_plan_id).first
    membership = Membership.where(group_id: group.id, user_id: current_user.id).first
    selected_by_id = params[:declined_by_id]
    declined_by_id = params[:declined_by_id]
    properties = params[:properties]

    application = Application.create! \
      account_id: account.id,
      benefit_plan_id: benefit_plan.id,
      membership_id: membership.id,
      selected_by_id: selected_by_id,
      selected_on: (selected_by_id ? DateTime.now : nil),
      declined_by_id: declined_by_id,
      declined_on: (declined_by_id ? DateTime.now : nil),
      properties: properties

    respond_to do |format|
      format.json {
        render json: {
          application: render_application(application)
        }
      }
    end
  end

  def show
    application = Application.find(params[:id].to_i)

    respond_to do |format|
      format.json {
        render json: {
          application: render_application(application)
        }
      }
    end
  end

  # TODO: Finish this
  # TODO: Optimize this
  # TODO: Add some logging in here
  def update
    application = Application.find(params[:id])
    benefit_plan_id = params[:benefit_plan_id]
    declined_by_id = params[:declined_by_id]
    applied_by_id = params[:applied_by_id]
    approved_by_id = params[:approved_by_id]
    submitted_by_id = params[:submitted_by_id]
    properties = params[:properties]

    if benefit_plan_id
      application.update_attribute(:benefit_plan_id, benefit_plan_id)
    end

    if declined_by_id
      application.update_attributes \
        declined_by_id: declined_by_id,
        declined_on: DateTime.now
    end

    if applied_by_id
      application.update_attributes \
        applied_by_id: applied_by_id,
        applied_on: DateTime.now
    end

    if approved_by_id
      application.update_attributes \
        approved_by_id: approved_by_id,
        approved_on: DateTime.now
    end

    # TODO: Return activity log from PokitDok and show it in the eligibility status modal.
    if submitted_by_id
      application.update_attributes \
        submitted_by_id: submitted_by_id,
        submitted_on: DateTime.now

      # pokitdok = PokitDok::PokitDok.new \
      #   Rails.application.config.pokitdok.client_id,
      #   Rails.application.config.pokitdok.client_secret

      # # TODO: Write a method to translate application properties into PokitDok request data.
      # data = sample_data

      # begin
      #   response = pokitdok.enrollment(data)
      #   meta = attempt['meta'] || {}
      #   activity_id = meta['activity_id']

      #   attempt.create! \
      #     response: response,
      #     activity_id: activity_id,
      #     application_id: application_id

      #   application.update_attributes \
      #     submitted_by_id: submitted_by_id,
      #     submitted_on: DateTime.now
      # rescue StandardError => e
      #   response = JSON.parse(e.response.body)
      #   error_type = e.class

      #   attempt.create! \
      #     response: response,
      #     error_type: error_type,
      #     application_id: application_id

      #   application.update_attributes \
      #     errored_by_id: submitted_by_id
      # end
    end

    if properties
      application.update_attribute(:properties, properties)
    end

    respond_to do |format|
      format.json {
        render json: {
          application: render_application(application)
        }
      }
    end
  end

  def destroy
    application = Application.find(params[:id])

    application.destroy!

    respond_to do |format|
      format.json {
        render json: {
          application: {}
        }
      }
    end
  end

  def last_attempt
    application = Application.find(params[:application_id])

    # Application has been submitted to PokitDok.
    if application.sent_on
      last_attempt = application.attempts.last
      pokitdok = PokitDok::PokitDok.new \
        Rails.application.config.pokitdok.client_id,
        Rails.application.config.pokitdok.client_secret

      response = nil

      if last_attempt && last_attempt.activity_id
        begin
          response = pokitdok.activities({
            activity_id: last_attempt.activity_id
          })
        rescue StandardError => e
          # TODO: Do something
          response = nil
        end
      end

      respond_to do |format|
        format.json {
          render json: {
            attempt: response
          }
        }
      end

      return
    end

    # Application has not yet been submitted to PokitDok.
    respond_to do |format|
      format.json {
        render json: {
          attempt: {
            state: 'pending'
          }
        }
      }
    end
  end

  # Render methods

  def render_application(application)
    membership = application.membership

    application.as_json.merge({
      'benefit_plan' => application.benefit_plan,
      'membership' => membership.as_json.merge({
        'group' => membership.group,
        'applications' => membership.applications
      }),
      'state' => application.state,
      'human_state' => application.state.titleize,
      'state_label' => application.state_label
    })
  end

  # # TODO: Get rid of this
  # def sample_data
  #   {
  #     action: 'Change',
  #     broker: {
  #       name: 'MONEY TALKS BROKERAGE',
  #       tax_id: '123356799',
  #       account_numbers: ['123', '456']
  #     },
  #     dependents: [],
  #     master_policy_number: 'ABCD012354',
  #     payer: {
  #       tax_id: '654456654'
  #     },
  #     purpose: 'Original',
  #     reference_number: '12456',
  #     sponsor: {
  #       tax_id: '999888777'
  #     },
  #     subscriber: {
  #       address: {
  #         city: 'CAMP HILL',
  #         county: 'CUMBERLAND',
  #         line: '100 MARKET ST',
  #         line2: 'APT 3G',
  #         postal_code: '17011',
  #         state: 'PA'
  #       },
  #       benefit_status: 'Active',
  #       benefits: [
  #         {
  #           begin_date: 'Sat Jun  1 00:00:00 1996',
  #           benefit_type: 'Health',
  #           coordination_of_benefits: [
  #             {
  #               group_or_policy_number: '890111',
  #               payer_responsibility: 'Primary',
  #               status: 'Unknown'
  #             }
  #           ],
  #           late_enrollment: false,
  #           maintenance_type: 'Addition'
  #         },
  #         {
  #           begin_date: 'Sat Jun  1 00:00:00 1996',
  #           benefit_type: 'Dental',
  #           late_enrollment: false,
  #           maintenance_type: 'Addition'
  #         },
  #         {
  #           begin_date: 'Sat Jun  1 00:00:00 1996',
  #           benefit_type: 'Vision',
  #           late_enrollment: false,
  #           maintenance_type: 'Addition'
  #         }
  #       ],
  #       birth_date: 'Fri Aug 16 00:00:00 1940',
  #       contacts: [
  #         {
  #           communication_number2: '7172341240',
  #           communication_type2: 'Work Phone Number',
  #           primary_communication_number: '7172343334',
  #           primary_communication_type: 'Home Phone Number'
  #         }
  #       ],
  #       eligibility_begin_date: 'Thu May 23 00:00:00 1996',
  #       employment_status: 'Full-time',
  #       first_name: 'JOHN',
  #       gender: 'Male',
  #       group_or_policy_number: '123456001',
  #       handicapped: false,
  #       last_name: 'DOE',
  #       maintenance_reason: 'Active',
  #       maintenance_type: 'Addition',
  #       member_id: '123456789',
  #       middle_name: 'P',
  #       relationship: 'Self',
  #       ssn: '123456789',
  #       subscriber_number: '123456789',
  #       substance_abuse: false,
  #       tobacco_use: false
  #     },
  #     trading_partner_id: 'MOCKPAYER'
  #   }
  # end
end

