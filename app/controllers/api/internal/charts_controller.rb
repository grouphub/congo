class Api::Internal::ChartsController < ApplicationController
  protect_from_forgery

  before_filter :ensure_user!
  before_filter :ensure_account!
  before_filter :ensure_broker_or_group_admin!

  def members_status
    start_data = {
      submitted: 0,
      completed: 0,
      selected: 0,
      not_started: 0,
      invited: 0
    }

    series = ['Members']
    labels = ['Invited', 'Not Started', 'Selected', 'Completed', 'Submitted']
    data = [0, 0, 0, 0, 0]

    hash = current_account.memberships
      .includes(:applications)
      .inject(start_data) { |hash, membership|
        application = membership.applications.last

        next(hash) if application.nil?

        if application.submitted_by_id
          # Broker sent out application.
          hash[4] += 1
        elsif application.completed_by_id
          # User completed application.
          hash[3] += 1
        elsif application.selected_by_id
          # User selected an application.
          hash[2] += 1
        elsif membership.user_id.nil?
          # User hasn't signed up yet.
          hash[0] += 1
        else
          # User has signed up but hasn't enrolled yet.
          hash[1] += 1
        end

        hash
      }

    respond_to do |format|
      format.json {
        render json: {
          series: series,
          labels: labels,
          data: [data]
        }
      }
    end
  end
end
