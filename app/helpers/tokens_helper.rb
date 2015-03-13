module TokensHelper
  include ApplicationHelper

  def current_token
    @current_token ||= Token.where(unique_id: request.env['HTTP_GROUPHUB_TOKEN']).first
  end

  def ensure_token!
    unless current_token
      error_response('You must provide a valid token.')
      return
    end
  end
end

