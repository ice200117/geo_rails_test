#!/usr/bin/env ruby
#
# get_avg.rb
# Copyright (C) 2015-12-29 libaoxi <vagrant@vagrant-ubuntu-trusty-64>
#
# Distributed under terms of the MIT license.
#
def parse_lines(line)
	# sd = line[0,10]
	sd = line[0,2]
	delta_hour = line[0,2].to_i
	# sdate = Time.local(sd[0,4],sd[4,2],sd[6,2],sd[8,2])
	if delta_hour>28&&delta_hour<53
		return line[3,4].to_i
	elsif delta_hour<29
		return "small" 
	elsif delta_hour>52
		return "big"
	end
end

puts "---begin---"
path="/vagrant/201412/"
w = File.open(path+"0000.txt","w")
# path_w="/vagrant/201412/"
Dir::entries(path).each do |dirname|
	next if dirname.size < 3
    filename = "XJ_ENVAQFC_0052_HEBE_Langfang_#{dirname}20_00000-07200.TXT"
	f = File.open(path+dirname+"/"+filename,"r") if File.exists?(path+dirname+"/"+filename)
	next unless f
	ary = Array.new
	datalines = f.readlines
	datalines[25..55].each do |line|
		tmp = parse_lines(line)
		if tmp.class == 0.class
			# puts sdate.to_s+delta_hour.to_s
			ary << tmp
		elsif tmp == "small"
			next
		elsif tmp == "big"
			break
		end	
	end
	p ary.size
	if ary.size == 24
		avg = ary.inject(0){|sum,x| sum+=x}/ary.length 
		w.puts(dirname+" "+avg.to_s)
	else
		w.puts(dirname+" "+"数据个数有错误！")
	end
end
w.close
puts "---end---"
