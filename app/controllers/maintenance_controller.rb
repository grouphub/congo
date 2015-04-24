class MaintenanceController < ApplicationController
  skip_before_filter :check_maintenance

  def index
    render text: 'Currently in maintenance mod.'
  end
end

