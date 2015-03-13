class Api::Internal::TokensController < ApplicationController
  protect_from_forgery

  # TODO: Move other controllers over to this style
  before_filter :ensure_user!
  before_filter :ensure_account!
  before_filter :ensure_broker!

  def index
    tokens = current_account.tokens

    respond_to do |format|
      format.json {
        render json: {
          tokens: current_account.tokens
        }
      }
    end
  end

  def create
    name = params[:name]

    unless name
      # TODO: Test this
      error_response('Name must be provided.')
      return
    end

    token = Token.create! \
      account_id: current_account.id,
      name: name

    respond_to do |format|
      format.json {
        render json: {
          token: token
        }
      }
    end
  end

  def destroy
    token_id = params[:id]
    token = Token.where(account_id: current_account.id, id: token_id).first

    unless token
      # TODO: Test this
      error_response('Matching token could not be found.')
      return
    end

    token.destroy!

    respond_to do |format|
      format.json {
        render json: {
          token: token
        }
      }
    end
  end
end

