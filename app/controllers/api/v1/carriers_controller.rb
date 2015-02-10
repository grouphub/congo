class Api::V1::CarriersController < ApplicationController
  before_filter :authenticate_admin!, except: :index

  def index
    # TODO: Check for current user and admin

    respond_to do |format|
      format.json {
        render json: {
          # TODO: Scope groups by account
          carriers: Carrier.all
        }
      }
    end
  end

  def create
    # TODO: Check for current user and admin

    properties = params[:properties]
    name = properties['name']

    # Split service types
    properties['service_types'] ||= ''
    properties['service_types'] = properties['service_types'].split(/,\s*/)

    unless name
      # TODO: Handle this
    end

    carrier = Carrier.create! \
      name: name,
      properties: properties

    respond_to do |format|
      format.json {
        render json: {
          carrier: carrier
        }
      }
    end
  end

  def show
    # TODO: Check for current user and admin

    slug = params[:id]
    carrier = Carrier.where(slug: slug).first

    respond_to do |format|
      format.json {
        render json: {
          carrier: carrier
        }
      }
    end
  end

  def destroy
    # TODO: Check for current user and admin

    carrier = Carrier.find(params[:id])
    carrier.destroy!

    respond_to do |format|
      format.json {
        render json: {
          carrier: {}
        }
      }
    end
  end
end

