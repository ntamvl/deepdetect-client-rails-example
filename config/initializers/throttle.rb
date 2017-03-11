require "redis"

redis_conf  = YAML.load(File.join(Rails.root, "config", "redis.yml"))
REDIS = Redis.new(:host => redis_conf["host"], :port => redis_conf["port"])

# Allow an token to make 500 requests every 5 minutes
THROTTLE_TIME_WINDOW = 5 * 60 # 300 seconds
THROTTLE_MAX_REQUESTS = 500 # 500 number of requests
