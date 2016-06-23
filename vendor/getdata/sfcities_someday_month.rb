#!/usr/bin/env ruby
#
# sfcities_someday_month.rb
# Copyright (C) 2016 libaoxi <693879111@qq.com>
#
# Distributed under terms of the MIT license.
#
require_relative './common.rb'

#历史脚本通用方法
def histroy_common(stime,etime,city_list,model)
	while stime<etime
		common_get_month_year(city_list,model,stime)
		stime += 60*60*24
	end
end
stime = '20160616'.to_time
etime = stime.end_of_day

#74城市月数据
histroy_common(stime,etime,'china_city_74',TempSfcitiesMonth)
