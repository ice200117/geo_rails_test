#!/usr/bin/env ruby
#
# redis.rb
# Copyright (C) 2016 libaoxi <693879111@qq.com>
#
# Distributed under terms of the MIT license.
#

module Custom::Redis
	OPEN = true
	# OPEN = false
	#缓存公用方法,time==0时永不过期
	def self.set(name,data,time=0)
		if $redis.set(name,data.to_json)=='OK'
			$redis.expire(name,time) if time != 0
			data.as_json
		else
			nil
		end
	end

	def self.get(name)
		return nil unless OPEN
		data=$redis.get(name)
		if data.nil?
			nil
		else
			JSON.parse(data) 
		end
  end

  def self.del(name)
		$redis.del(name)
  end
end
