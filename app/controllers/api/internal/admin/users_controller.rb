class Api::Internal::Admin::UsersController < Api::ApiController
  protect_from_forgery

  before_filter :ensure_admin!, except: :index

  def index
    respond_to do |format|
      format.json {
        render json: {
          users: User.all.map { |user|
            render_user(user)
          }
        }
      }
    end
  end

  def crystal_ball
    crystal_ball!(params[:user_id].to_i)

    respond_to do |format|
      format.json {
        render json: {
          user: render_user(current_user)
        }
      }
    end
  end
end

