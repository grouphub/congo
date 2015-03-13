class Api::Internal::Admin::GroupsController < ApplicationController
  protect_from_forgery

  before_filter :ensure_admin!, except: :index

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

