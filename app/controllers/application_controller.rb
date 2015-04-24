class ApplicationController < ActionController::Base
  include UsersHelper

  before_filter :check_maintenance

  def check_maintenance
    if Maintenance.in_progress?
      render :file => 'public/maintenance.html', :layout => false
    end
  end
end

