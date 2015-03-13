class Api::V1::SamplesController < ApplicationController
  def show
    render text: request.env['HTTP_GROUPHUB_TOKEN']
  end
end

