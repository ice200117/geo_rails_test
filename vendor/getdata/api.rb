#!/usr/bin/env ruby
#
# api.rb
# Copyright (C) 2016 vagrant <vagrant@vagrant-ubuntu-trusty-64>
#
# Distributed under terms of the MIT license.
#


class Api
	@shishi74='http://www.izhenqi.cn/api/getdata_cityrank.php'
	@history_74='http://www.izhenqi.cn/api/getdata_history.php'
	@shishi_rank='http://www.izhenqi.cn/api/getrank.php'
	@rank_74_month='http://www.izhenqi.cn/api/getrank_month.php'
	@zhzs_74='http://www.izhenqi.cn/api/getrank_forecast.php'
	@history_lf='http://115.28.227.231:8082/api/data/day-qxday'
	@all_city_by_hour='http://www.izhenqi.cn/api/dataapi.php'
	def strftime(data)
		date.strftime("%Y-%m-%d")
	end
	def jjj_day(time)
		connect_test('TemJjjDay',)
	end
	hs = Hash.new
	begin
		if web_flag == 'rank_74_shishi'
			#真气网74城市实时/日排名
			response = HTTParty.get('secret='+secretstr+'&type='+typestr+'&key='+Digest::MD5.hexdigest(secretstr+typestr))
		elsif web_flag == 'history_74' 
			#74城市和京津冀历史日接口
			option = {secret:secretstr,type:typestr,date:datestr,key:Digest::MD5.hexdigest(secretstr+typestr+datestr)}
			response = HTTParty.post('http://www.izhenqi.cn/api/getdata_history.php', :body => option)
		elsif web_flag == 'shishi_rank' 
			#74城市 京津冀 廊坊实时数据
			option = {secret:secretstr,type:typestr,key:Digest::MD5.hexdigest(secretstr+typestr) }
			response = HTTParty.post('http://www.izhenqi.cn/api/getrank.php', :body => option)
		elsif web_flag == 'rank_74_month'
			#74城市月排名数据
			option = {secret:secretstr,type:typestr,date:datestr,key:Digest::MD5.hexdigest(secretstr+typestr+datestr) }
			response = HTTParty.post('http://www.izhenqi.cn/api/getrank_month.php', :body => option)
		elsif web_flag == 'zhzs_74'
			#74 城市当月和当年综合指数排名
			option = {secret:secretstr,type:typestr,key:Digest::MD5.hexdigest(secretstr+typestr) }
			response = HTTParty.post('http://www.izhenqi.cn/api/getrank_forecast.php', :body => option)
		elsif web_flag == 'history_lf'
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
