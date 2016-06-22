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
			puts l['data_real_time'].to_s+'   '+count.to_s
		end
	end
	model.where(data_real_time:(stime..etime)).each do |l|
		if hs[l.id].nil?
			next
		else
			l.rank = hs[l.id] 
		end
		l.save
	end
end

