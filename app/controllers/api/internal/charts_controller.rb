class Api::Internal::ChartsController < ApplicationController
  protect_from_forgery

  before_filter :ensure_user!
  before_filter :ensure_account!
  before_filter :ensure_broker_or_group_admin!

  def members_status
    keys = {
      submitted: 4,
      completed: 3,
      selected: 2,
      not_started: 1,
      invited: 0
    }

    start_data = [0, 0, 0, 0, 0]
    series = ['Members']
    labels = ['Invited', 'Not Started', 'Selected', 'Completed', 'Submitted']

    data = current_account.memberships
      .includes(:applications)
      .inject(start_data) { |list, membership|
        application = membership.applications.last

        if !application
          # User has signed up but hasn't enrolled yet.
          list[keys[:invited]] += 1
        elsif application.submitted_by_id
          # Broker sent out application.
          list[keys[:submitted]] += 1
        elsif application.completed_by_id
          # User completed application.
          list[keys[:completed]] += 1
        elsif application.selected_by_id
          # User selected an application.
          list[keys[:selected]] += 1
        elsif membership.user_id.nil?
          # User hasn't signed up yet.
          list[keys[:not_started]] += 1
        end

        list
      }

    pp data

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
