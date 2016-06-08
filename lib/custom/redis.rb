#!/usr/bin/env ruby
#
# redis.rb
# Copyright (C) 2016 libaoxi <693879111@qq.com>
#
# Distributed under terms of the MIT license.
#

module Custom::Redis
	#缓存公用方法,time==0时永不过期
	def self.set(name,data,time=0)
		$redis.del(name)
		if $redis.set(name,data.to_json)=='OK'
			time == 0 ? true : $redis.expire(name,time)
		else
			nil
		end
		data.as_json
	end

	def self.get(name)
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
