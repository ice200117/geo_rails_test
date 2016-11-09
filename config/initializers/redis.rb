#!/usr/bin/env ruby
#
# redis.rb
# Copyright (C) 2016 libaoxi <693879111@qq.com>
#
# Distributed under terms of the MIT license.
#
require "redis"
require "redis-namespace"
require "redis/objects"

redis_config = YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env]

$redis = Redis.new(host: redis_config['host'], port: redis_config['port'],:db=>1)
Redis::Objects.redis = $redis

sidekiq_url = "redis://#{redis_config['host']}:#{redis_config['port']}/11"
Sidekiq.configure_server do |config|
  config.redis = { namespace: 'sidekiq_palm', url: sidekiq_url }
end
Sidekiq.configure_client do |config|
  config.redis = { namespace: 'sidekiq_palm', url: sidekiq_url }
end

# $redis = Redis.new(:host=>'127.0.0.1',:port => 6379)
