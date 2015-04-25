class Api::V1::SamplesController < Api::ApiController
  def show
    render text: request.env['HTTP_GROUPHUB_TOKEN']
  end
end

