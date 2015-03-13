Rack::Defense.setup do |config|
  config.store = Rails.application.config.redis.url

  requests_per_period = Rails.application.config.rate_limiting.requests_per_period
  period_in_milliseconds = Rails.application.config.rate_limiting.period_in_milliseconds

  if Rails.application.config.rate_limiting.enabled
    config.throttle('api_v1', requests_per_period, period_in_milliseconds) do |req|
      req.env['HTTP_GROUPHUB_TOKEN'] if %r{^/api/v1/} =~ req.path
    end
  end
end

