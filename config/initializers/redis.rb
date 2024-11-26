Redis::Objects.redis = ConnectionPool.new(size: ENV.fetch('REDIS_POOL_SIZE', 5)) do
  Redis.new(url: ENV.fetch('REDIS_URL'))
end
