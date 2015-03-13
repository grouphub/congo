class Api::V1::Admin::GroupsController < ApplicationController
  protect_from_forgery

  before_filter :authenticate_admin!, except: :index

  def index
    respond_to do |format|
      format.json {
        render json: {
          groups: Group.all.includes(:account).map { |group|
            group.as_json.merge({
              account: group.account
            })
          }
        }
      }
    end
  end
end

