class Api::V1::GroupsController < ApplicationController
  def index
    respond_to do |format|
      format.json {
        render json: {
          # TODO: Scope groups by account
          groups: Group.all
        }
      }
    end
  end

  def create
    name = params[:name]

    unless name
      # TODO: Handle this
    end

    group = Group.create! \
      name: name

    respond_to do |format|
      format.json {
        render json: group
      }
    end
  end

  def destroy
    id = params[:id]

    group = Group.find(id).destroy

    respond_to do |format|
      format.json {
        render json: group
      }
    end
  end
end


