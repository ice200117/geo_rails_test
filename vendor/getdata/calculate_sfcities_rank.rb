#!/usr/bin/env ruby
#
# calculate_sfcities_rank.rb
# Copyright (C) 2016 libaoxi <693879111@qq.com>
#
# Distributed under terms of the MIT license.
#

def model(model,stime,etime)
	hs = Hash.new
	model.order(:zonghezhishu).where(data_real_time: (stime..etime)).to_a.group_by_day(&:data_real_time).each do |k,v|
		# v.sort_by!{|x| x['zonghezhishu']}
		count = 0
		v.each do |l|
			count += 1
			hs[l['id']] = count
			puts l['id'].to_s+' '+l['data_real_time'].to_s+'   '+count.to_s + ' '+l['zonghezhishu'].to_s
		end
		puts ' '
	end
	byebug
	model.where(data_real_time:(stime..etime)).each do |l|
		if hs[l.id].nil?
			next
		else
			l.rank = hs[l.id] 
		end
		l.save
		puts l.id.to_s+' '+l.data_real_time.to_s + ' ' + l.rank.to_s + ' ' + l.zonghezhishu.to_s + ' save ok!'
	end
end

model(TempSfcitiesMonth,'20150101'.to_time.beginning_of_day,Time.now.beginning_of_day)
model(TempSfcitiesYear,'20150101'.to_time.beginning_of_day,Time.now.beginning_of_day)
