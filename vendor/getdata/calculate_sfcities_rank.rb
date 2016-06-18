#!/usr/bin/env ruby
#
# calculate_sfcities_rank.rb
# Copyright (C) 2016 libaoxi <693879111@qq.com>
#
# Distributed under terms of the MIT license.
#

def model(model)
	model.all.group_by_day(&:data_real_time).each do |k,v|
		v.sort_by!{|x| x.zonghezhishu}
	end
end

