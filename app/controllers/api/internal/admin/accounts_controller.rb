class Api::Internal::Admin::AccountsController < ApplicationController
  protect_from_forgery

  before_filter :ensure_admin!, except: :index

  def index
    respond_to do |format|
      format.json {
        render json: {
          accounts: Account.all.includes(:roles).map { |account|
            account.as_json.merge({
              brokers: account.roles.includes(:user).where(name: 'broker').map { |role|
                role.user.as_json.merge({
                  full_name: role.user.full_name,
                  role: role
                })
              }
            })
          }
        }
      }
    end
  end
end

