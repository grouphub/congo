class Api::Internal::ApplicationsController < Api::ApiController
  protect_from_forgery

  before_filter :ensure_user!, except: :callback
  before_filter :ensure_account!, except: :callback

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
    membership = Membership.where(group_id: group.id, user_id: params[:user_id] || current_user.id).first
    selected_by_id = params[:selected_by_id]
    declined_by_id = params[:declined_by_id]
    properties = params[:properties]
    pdf_attachment_url = nil

    if params[:pdf_attachment].present?
      pdf_attachment = params[:pdf_attachment]
      S3.store(pdf_attachment.original_filename, pdf_attachment.tempfile, "application/pdf")
      pdf_attachment_url = S3.public_url(pdf_attachment.original_filename)
    end

    application = Application.create! \
      account_id: account.id,
      benefit_plan_id: benefit_plan.id,
      membership_id: membership.id,
      selected_by_id: selected_by_id,
      selected_on: (selected_by_id ? DateTime.now : nil),
      declined_by_id: declined_by_id,
      declined_on: (declined_by_id ? DateTime.now : nil),
      properties: properties,
      pdf_attachment_url: pdf_attachment_url

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

      approver_role = Role
        .where({
          account_id: current_account.id,
          name: current_role.name,
          user_id: current_user.id
        })
        .first

      # TODO: Verify this works
      member_notification = Notification.create! \
        subject: application,
        account_id: application.account.id,
        role_id: application.membership.role.id,
        title: %[One of your applications was approved!],
        description: %[The user "#{approver_role.user.email}" approved your application ] +
          %[for "#{application.benefit_plan.name}" in the account ] +
          %[#{application.account.name}.]

      NotificationMailer.notification_email(member_notification, request.protocol, request.host_with_port).deliver_later

      # TODO: Verify this works
      broker_notification = Notification.create! \
        subject: application,
        account_id: current_account.id,
        role_id: approver_role.id,
        title: %[You approved an application for "#{application.membership.user.email}"],
        description: %[You approved an application for the user ] +
          %[#{application.membership.user.email} for the plan ] +
          %["#{application.benefit_plan.name}" in the account ] +
          %[#{application.account.name}.]

      NotificationMailer.notification_email(broker_notification, request.protocol, request.host_with_port).deliver_later
    end

    # TODO: Return activity log from PokitDok and show it in the eligibility status modal.
    if submitted_by_id
      application.update_attributes \
        submitted_by_id: submitted_by_id,
        submitted_on: DateTime.now

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

  def activities
    application = Application.find(params[:application_id])

    # Application has been submitted to PokitDok.
    if application.completed_on || application.errored_on
      response = nil

      begin
        response = pokitdok.activities({
          activity_id: application.activity_id
        })
      rescue StandardError => e
        # TODO: Do something
        response = nil
      end

      respond_to do |format|
        format.json {
          render json: {
            activities: response
          }
        }
      end

      return
    end

    # Application has not yet been submitted to PokitDok.
    respond_to do |format|
      format.json {
        render json: {
          activities: {
            meta: {

            },
            data: [
              {
                parameters: {
                  state: {
                    name: 'pending',
                    title: 'Pending'
                  },
                  history: [
                    record_dt: application.submitted_on,
                    name: 'pending',
                    title: 'Pending delivery'
                  ]
                }
              }
            ]
          }
        }
      }
    end
  end

  def callback
    account_slug = params[:account_slug]
    application_id = params[:application_id].to_i

    account = Account.where(slug: account_slug).first
    application = Application.find(application_id)

    unless application.account_id == account.id
      error_response('Account does not contain this application.')
      return
    end

    if application.application_status
      application.application_status.update_attributes! \
        payload: response.to_json
    else
      ApplicationStatus.create! \
        application_id: application,
        payload: response.to_json
    end

    render :nothing => true
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
      'human_state' => application.human_state,
      'state_label' => application.state_label
    })
  end
end

