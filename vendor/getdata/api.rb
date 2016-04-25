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
	def shishi_74
		#真气网74城市实时/日排名
		response = HTTParty.get('http://www.izhenqi.cn/api/getdata_cityrank.php?secret='+secretstr+'&type='+typestr+'&key='+Digest::MD5.hexdigest(secretstr+typestr))
	end
	def history_74
		#74城市和京津冀历史日接口
		option = {secret:secretstr,type:typestr,date:datestr,key:Digest::MD5.hexdigest(secretstr+typestr+datestr)}
		response = HTTParty.post('http://www.izhenqi.cn/api/getdata_history.php', :body => option)
	end
	def shishi_74_jjj
		#74城市 京津冀 廊坊实时数据
		option = {secret:secretstr,type: typestr,key:Digest::MD5.hexdigest(secretstr+typestr) }
		response = HTTParty.post('http://www.izhenqi.cn/api/getrank.php', :body => option)
	end
	def rank_month_74
		#74城市月排名数据
		option = {secret:secretstr,type:typestr,date:datestr,key:Digest::MD5.hexdigest(secretstr+typestr+datestr) }
		response = HTTParty.post('http://www.izhenqi.cn/api/getrank_month.php', :body => option)
	end
	def years_month_zhzs_74
		#74 城市当月和当年综合指数排名
		option = {secret:secretstr,type:typestr,key:Digest::MD5.hexdigest(secretstr+typestr) }
		response = HTTParty.post('http://www.izhenqi.cn/api/getrank_forecast.php', :body => option)
	end
	def history_lf
		#廊坊区县历史数据排名
		response  = HTTParty.get('http://115.28.227.231:8082/api/data/day-qxday?date='+datestr)
	end
	def whole_country_hour
		#全国城市小时数据
		option = {secret:secretstr,method:methodstr,type:typestr,key:Digest::MD5.hexdigest(secretstr+methodstr+typestr) }
		response = HTTParty.post('http://www.izhenqi.cn/api/dataapi.php',:body => option)
	end
	def get_rank_json(web_flag,secretstr,typestr,datestr)
		datestr=datestr.strftime("%Y-%m-%d") if datestr != nil
		methodstr = ''
		if secretstr.class == Hash
			methodstr=secretstr[:metho d]
			secretstr=secretstr[:secret]
		end
		hs = Hash.new
		elsif web_flag == 'all_city_by_hour'
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
