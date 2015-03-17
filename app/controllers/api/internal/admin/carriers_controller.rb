class Api::Internal::Admin::CarriersController < ApplicationController
  protect_from_forgery

  before_filter :ensure_admin!, except: :index

  def index
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
    properties = params[:properties]
    name = properties['name']

    unless name
      # TODO: Test this
      error_response('Name must be provided.')
      return
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
    slug = params[:id]
    carrier = Carrier.where(slug: slug).first

    unless carrier
      # TODO: Test this
      error_response('Could not find a matching carrier.')
      return
    end

    respond_to do |format|
      format.json {
        render json: {
          carrier: carrier
        }
      }
    end
  end

  def update
    slug = params[:id]
    carrier = Carrier.where(slug: slug).first

    unless carrier
      # TODO: Test this
      error_response('Could not find a matching carrier.')
      return
    end

    properties = params[:properties]
    name = properties['name']

    unless name
      # TODO: Test this
      error_response('Name must be provided.')
      return
    end

    carrier.update_attributes! \
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

  def destroy
    carrier = Carrier.find(params[:id])

    unless carrier
      # TODO: Test this
      error_response('Could not find a matching carrier.')
      return
    end

    carrier.destroy!

    respond_to do |format|
      format.json {
        render json: {
          carrier: carrier
        }
      }
    end
  end
end

