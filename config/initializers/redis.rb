Redis.current = Redis::Namespace.new \
  Rails.application.config.redis.namespace,
  redis: Redis.new(url: Rails.application.config.redis.url)

