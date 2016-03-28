#!/usr/bin/env ruby
#
# import_eventserver.rb
# Copyright (C) 2016 vagrant <vagrant@vagrant-ubuntu-trusty-64>
#
# Distributed under terms of the MIT license.
#
require 'rainbow/ext/string'
require 'predictionio'
namespace :import do
	desc 'Send the data to PredictionIO'
	task :predictionio => :environment do
		puts 'Starting import...'.color(:blue)
		PIO_ACCESS_KEY = 'bvBb63K0L34grAX23yzOfRLFbs6emKGHWoJMZbs7o8zhH1eTf8Lmqk03Y43vVg3H'
		PIO_EVENT_SERVER_URL = 'http://localhost:7070'
		PIO_THREADS = 50
		client = PredictionIO::EventClient.new(PIO_ACCESS_KEY, PIO_EVENT_SERVER_URL,PIO_THREADS)
		path = "/mnt/share/Temp/station_15km_orig" #气象文件目录
		folders = (20160309..20160314).to_a.map{|x| x.to_s} #气象文件文件夹的名字
		stime = '20160309'.to_time
		etime = '20160314'.to_time
		cch = ChinaCitiesHour.where("data_real_time >= ? AND data_real_time <= ? AND city_id = ?",stime,etime,18)
		aqi_time=Hash.new
		cch.each{|x| aqi_time[x.data_real_time.beginning_of_hour] = x.AQI}
		lines=Array.new #所有内容,每一行都是一个hash
		count = 0
		folders.each do |foldername|
			# byebug
			kv=Hash.new #每一行的数据都写成一个哈希
			filename="CN_MET_langfangshi_#{foldername}20_00000-12000.TXT"
			next if !File.exists?(path+'/'+foldername+'/'+filename)
			lines=File.open(path+'/'+foldername+'/'+filename,'r')
			lines.readlines[1..-1].each do |line|
				time = line[0,10].to_time+line[11,3].to_i*3600
				next if aqi_time[time].nil?
				attr=line.split(" ")
				client.create_event(
					event="$set", 
					entity_type="training_point",
					entity_id=count.to_s,	# use the count num as user ID 
					properties = Hash[ 
						# 气象文件中一共29个字段，第一个是时间,所以从第2个字段开始的
						"attr0"=> attr[1].to_f,
						"attr1"=> attr[2].to_f,
						"attr2"=> attr[3].to_f,
						"attr3"=> attr[4].to_f,
						"attr4"=> attr[5].to_f,
						"attr5"=> attr[5].to_f,
						"attr6"=> attr[7].to_f, 
						"attr7"=> attr[8].to_f, 
						"attr8"=> attr[9].to_f,
						"attr9"=> attr[10].to_f,
						"attr10"=> attr[11].to_f,
						"attr11"=> attr[12].to_f,
						"attr12"=> attr[13].to_f,
						"attr13"=> attr[14].to_f,
						"attr14"=> attr[15].to_f,
						"attr15"=> attr[16].to_f,
						"attr16"=> attr[17].to_f,
						"attr17"=> attr[18].to_f,
						"attr18"=> attr[19].to_f,
						"attr19"=> attr[20].to_f,
						"attr20"=> attr[21].to_f,
						"attr21"=> attr[22].to_f,
						"attr22"=> attr[23].to_f,
						"attr23"=> attr[24].to_f,
						"attr24"=> attr[25].to_f,
						"attr25"=> attr[26].to_f,
						"attr26"=> attr[27].to_f,
						"attr27"=> attr[28].to_f,
						# "attr2=>08"  attr[28].to_f,
						"plan" => aqi_time[time].to_f
					]

				)
				count += 1
			end
			print "%s events are imported.\n" % count
		end
	end
end
