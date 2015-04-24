class RedisStore
  def self.store
    Redis::Namespace.new \
      Rails.application.config.redis.namespace,
      redis: Rails.application.config.redis.url
  end
end

