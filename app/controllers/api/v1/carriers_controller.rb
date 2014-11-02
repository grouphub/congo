class Api::V1::CarriersController < ApplicationController
  def index
    respond_to do |format|
      format.json {
        render json: {
          # TODO: Scope groups by account
          groups: Carrier.all
        }
      }
    end
  end

  def create
  end
end

