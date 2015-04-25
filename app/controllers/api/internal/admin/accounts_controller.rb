class Api::Internal::Admin::AccountsController < Api::ApiController
  protect_from_forgery

  before_filter :ensure_admin!, except: :index

  def index
    accounts = Account.all.includes({ roles: :user }, :groups)

    respond_to do |format|
      format.json {
        render json: {
          accounts: accounts.map { |account|
            account.as_json.merge({
              'groups' => account.groups,
              'roles' => account.roles.map { |role|
                role.as_json.merge({
                  'user' => role.user.as_json
                    .except(:encrypted_password)
                    .merge({
                      'is_admin' => role.user.admin?,
                      'full_name' => role.user.full_name
                    })
                })
              }
            })
          }
        }
      }
    end
  end
end

