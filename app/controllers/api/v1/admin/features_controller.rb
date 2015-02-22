class Api::V1::Admin::FeaturesController < ApplicationController
  before_filter :authenticate_admin!, except: :index

  # TODO: Ensure admin.
  def index
    respond_to do |format|
      format.json {
        render json: {
          features: Feature.all
        }
      }
    end
  end

  # TODO: Ensure admin.
  # TODO: Surface error if feature does not exist.
  def create
    feature = Feature.new

    feature.name = params[:name]
    feature.description = params[:description]
    feature.account_slugs = params[:account_slugs]
    feature.enabled_for_all = params[:enabled_for_all]

    feature.save!

    respond_to do |format|
      format.json {
        render json: {
          feature: feature
        }
      }
    end
  end

  # TODO: Ensure admin.
  # TODO: Surface error if feature does not exist.
  def update
    feature = Feature.find(params[:id])

    feature.name = params[:name]
    feature.description = params[:description]
    feature.account_slugs = params[:account_slugs]
    feature.enabled_for_all = params[:enabled_for_all]

    feature.save!

    respond_to do |format|
      format.json {
        render json: {
          feature: feature
        }
      }
    end
  end

  # TODO: Ensure admin.
  # TODO: Surface error if feature does not exist.
  def destroy
    id = params[:id]

    Feature.find(id).destroy

    respond_to do |format|
      format.json {
        render json: {
          feature: nil
        }
      }
    end
  end
end

