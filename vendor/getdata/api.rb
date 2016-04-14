#!/usr/bin/env ruby
require_relative 'common.rb'
##
# api.rb
#
# Copyright (C) 2016 libaoxi <693879111@qq.com>
#
# Distributed under terms of the MIT license.
#

class Api
	def get_rank_json(web_flag,secretstr,typestr,datestr)
		datestr=datestr.strftime("%Y-%m-%d") if datestr != nil
		methodstr = ''
		if secretstr.class == Hash
			methodstr=secretstr[:method]
			secretstr=secretstr[:secret]
		end
		hs = Hash.new
		begin
			def city_74
				#真气网74城市实时/日排名
				response = HTTParty.get('http://www.izhenqi.cn/api/getdata_cityrank.php?secret='+secretstr+'&type='+typestr+'&key='+Digest::MD5.hexdigest(secretstr+typestr))
			end
			def city_74
				#74城市和京津冀历史日接口
				option = {secret:secretstr,type:typestr,date:datestr,key:Digest::MD5.hexdigest(secretstr+typestr+datestr)}
				response = HTTParty.post('http://www.izhenqi.cn/api/getdata_history.php', :body => option)
			end
				#74城市 京津冀 廊坊实时数据
				option = {secret:secretstr,type:typestr,key:Digest::MD5.hexdigest(secretstr+typestr) }
				response = HTTParty.post('http://www.izhenqi.cn/api/getrank.php', :body => option)
			elsif web_flag == 'china_rank_data_of_month'
				#74城市月排名数据
				option = {secret:secretstr,type:typestr,date:datestr,key:Digest::MD5.hexdigest(secretstr+typestr+datestr) }
				response = HTTParty.post('http://www.izhenqi.cn/api/getrank_month.php', :body => option)
			elsif web_flag == 'sfcitiesrankbymonthoryear'
				#74 城市当月和当年综合指数排名
				option = {secret:secretstr,type:typestr,key:Digest::MD5.hexdigest(secretstr+typestr) }
				response = HTTParty.post('http://www.izhenqi.cn/api/getrank_forecast.php', :body => option)
			elsif web_flag == 'lf_history_data'
				#廊坊区县历史数据排名
				response  = HTTParty.get('http://115.28.227.231:8082/api/data/day-qxday?date='+datestr)
			elsif web_flag == 'all_city_by_hour'
				#全国城市小时数据
				option = {secret:secretstr,method:methodstr,type:typestr,key:Digest::MD5.hexdigest(secretstr+methodstr+typestr) }
				response = HTTParty.post('http://www.izhenqi.cn/api/dataapi.php',:body => option)
			end
			json_data = ''
			if web_flag == 'all_city_by_hour'
				json_data=JSON.parse(Base64.decode64(response.body))
			else
				json_data=JSON.parse(response.body)
			end
			json_data['date'] != nil ? hs[:time] = json_data['date'] : hs[:time] = json_data['time']
			hs[:cities] = column_name_modify(json_data['rows'])
			hs[:total]=json_data['total']
		rescue
			hs=false
		end 
		hs
	end
end
