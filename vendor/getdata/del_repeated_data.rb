#!/usr/bin/env ruby
#
# del_repeated_data.rb
# Copyright (C) 2016 libaoxi <693879111@qq.com>
#
# Distributed under terms of the MIT license.
#

#删除某段时间的重复数据

def del(model,stime,etime)
	data = model.where(data_real_time:(stime..etime)).group_by{|s| s.city_id}
	data.each do |k,v|
		if v.length > 1
			for i in (1..v.length-1)
				model.find(v[i].id).destroy
				puts v[i].id.to_s+' '+v[i].data_real_time.to_s+' '+v[i].city_id.to_s+'destroy !'
			end		
		end
	end
end
stime='20160618'.to_time
etime=stime.end_of_day
del(TempJjjMonth,stime,etime)
del(TempJjjYear,stime,etime)
del(TempSfcitiesMonth,stime,etime)
del(TempSfcitiesYear,stime,etime)
