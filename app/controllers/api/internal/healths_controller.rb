class Api::Internal::HealthsController < Api::ApiController
  def show
    render text: 'OK'
  end
end

