class Api::ApiController < ApplicationController
  before_filter :check_maintenance

  def check_maintenance
    if Maintenance.in_progress?
      render :json => {
        maintenance: true
      }
    end
  end
end

