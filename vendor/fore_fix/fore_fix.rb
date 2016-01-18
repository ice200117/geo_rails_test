require_relative './city_enum.rb'
def get_monitor(id,time)
	model = get_model_by_id(id)
	return "city not find" if model == nil
	stime = time.beginning_of_hour
	etime = time.end_of_hour
	sql = Array.new
	sql << "data_real_time >= ? and data_real_time <= ? and id = ?"
	sql << stime
	sql << etime
	sql << id
	data_ary = model.where(sql)
	data_ary[0]
end

def get_forecast(stime,etime)
	stime = stime.beginning_of_hour
	etime = etime.end_of_hour
	sql = Array.new
	sql << "data_real_time => ? and data_real_time =< ?"
	sql << stime
	sql << etime
	data_ary = HourlyCityForecastAirQuality.where(sql)
	data_ary[0]
end

def get_model_by_name(city_name)
	model = false
	if CityEnum.baoding.include?(city_name)
		model = TempBdHour
	elsif CityEnum.langfang.include?(city_name)
		model = TempLfHour
	elsif CityEnum.china_city_74.include?(city_name)
		model = TempSfcitiesHour
	end
	model ? model : nil
end

def get_lev(a)
	if (0 .. 50) === a
		lev = 'you'
	elsif (50 .. 100) === a
		lev = 'yellow'
	elsif (100 .. 150) === a
		lev = 'qingdu'
	elsif (150 .. 200) === a
		lev = 'zhong'
	elsif (200 .. 300) === a
		lev = 'zhongdu'
	elsif (300 .. 5000) === a
		lev = 'yanzhong'
	end
end

#获取预报数据的预报时间，AQI
def get_aqi(line)
	sd = line[0,10]
	delta_hour = line[11,3]
	sdate = Time.local(sd[0,4],sd[4,2],sd[6,2],sd[8,2])

	hs = Hash.new
	hs[:forecast_datetime] = sdate+delta_hour.to_i*3600
	hs[:AQI] = line[14,4]
	hs
end

def lev()

end

def parse_line(line, c)
	hc = HourlyCityForecastAirQuality.new
	sd = line[0,10]
	delta_hour = line[11,3]
	sdate = Time.local(sd[0,4],sd[4,2],sd[6,2],sd[8,2])
	hc.publish_datetime = sdate
	hc.forecast_datetime = sdate+delta_hour.to_i*3600
	hc.AQI = line[14,4]
	hc.main_pol = line[18,13].strip
	hc.grade = line[31,1]
	hc.pm25 = line[99,6]
	hc.pm10 = line[87,6]
	hc.SO2 = line[39,6]
	hc.CO = line[63,6]
	hc.NO2 = line[51,6]
	hc.O3 = line[75,6]
	hc.VIS = line[32,7]
	hc.city_id = c.id
	hc.save
end

def fixed_write_txt(line,avg)
	aqi = line[14,4].to_i
	#line[14,4] = avg[get_lev(aqi)]*aqi if !avg[get_lev(aqi)].nil? 
	if !avg[get_lev(aqi)].nil? 
		fix_aqi = (aqi/avg[get_lev(aqi)]).round
		fix_aqi = 500 if fix_aqi > 500
		line[14,4] = " %3d" % fix_aqi
	end
	line
end

#设置9km缺省系数，与计算得到的系数求平均值
def default_9km
	cities_default=Hash.new
	city_index = station_ext()
	# north of JJJ
	cities_default['chengdeshi'] = {'you' =>0.6,'yellow' =>0.6,'qingdu'=>0.90,'zhong'=>1.01,'zhongdu'=>1.34,'yanzhong'=>1.51}
	cities_default['zhangjiakoushi'] = {'you' =>0.8,'yellow' =>0.9,'qingdu'=>0.90,'zhong'=>1.01,'zhongdu'=>1.34,'yanzhong'=>1.51}
	cities_default['qinhuangdaoshi'] = {'you' =>0.8,'yellow' =>0.9,'qingdu'=>0.90,'zhong'=>1.01,'zhongdu'=>1.34,'yanzhong'=>1.51}
	# end
	# centre of JJJ
	cities_default['beijingshi'] = {'you' =>0.70,'yellow' =>0.74,'qingdu'=>0.81,'zhong'=>0.94,'zhongdu'=>0.95,'yanzhong'=>0.85 }
	cities_default['baodingshi'] = {'you' =>0.80,'yellow' => 0.84,'qingdu'=>0.99,'zhong'=>1.05,'zhongdu'=>1.10,'yanzhong'=>1.11 }
	cities_default['langfangshi'] = {'you' =>0.70,'yellow' =>0.85,'qingdu'=>0.85,'zhong'=>0.91,'zhongdu'=>0.95,'yanzhong'=>0.95 }
	cities_default['tianjinshi'] = {'you' =>0.80,'yellow' =>0.80,'qingdu'=>0.85,'zhong'=>0.61,'zhongdu'=>0.65,'yanzhong'=>0.95 }
	
	# end 
	# south of JJJ
	cities_default['tangshanshi'] = {'you' =>0.8,'yellow' =>0.7,'qingdu'=>0.90,'zhong'=>1.01,'zhongdu'=>0.94,'yanzhong'=>1.01}
	cities_default['hengshuishi'] = {'you' =>0.8,'yellow' =>0.7,'qingdu'=>0.90,'zhong'=>0.91,'zhongdu'=>0.84,'yanzhong'=>0.81}
	cities_default['cangzhoushi'] = {'you' =>0.8,'yellow' =>0.6,'qingdu'=>0.96,'zhong'=>0.91,'zhongdu'=>0.84,'yanzhong'=>0.91}
	cities_default['xingtaishi'] = {'you' =>0.8,'yellow' =>0.7,'qingdu'=>0.90,'zhong'=>1.01,'zhongdu'=>1.04,'yanzhong'=>0.91}
	cities_default['handanshi'] = {'you' =>0.8,'yellow' =>0.7,'qingdu'=>0.90,'zhong'=>1.01,'zhongdu'=>1.04,'yanzhong'=>0.91}
	cities_default['shijiazhuangshi'] = {'you' =>0.70,'yellow' => 0.94,'qingdu'=>1.01,'zhong'=>0.95,'zhongdu'=>0.88,'yanzhong'=>0.81 }
	# end
	# liaoning 辽宁
	liaoningsheng = {'you' =>0.80,'yellow' => 0.94,'qingdu'=>1.01,'zhong'=>1.05,'zhongdu'=>1.08,'yanzhong'=>1.11 }
	for e in (44..56)
		# next if e == 93
		# puts e.to_s+' '+city_index[e]
		cities_default[city_index[e]] = liaoningsheng
	end		
	cities_default['shenyangshi'] = {'you' =>0.80,'yellow' => 0.94,'qingdu'=>1.01,'zhong'=>0.85,'zhongdu'=>0.98,'yanzhong'=>1.11 }
	# end
	# shanxi 山西
	cities_default['taiyuanshi'] = {'you' =>0.90,'yellow' => 1.04,'qingdu'=>1.11,'zhong'=>1.45,'zhongdu'=>1.68,'yanzhong'=>1.81 }
	cities_default['datongshi'] = {'you' =>0.8,'yellow' =>0.9,'qingdu'=>0.90,'zhong'=>1.01,'zhongdu'=>1.34,'yanzhong'=>1.51}
	# end

	cities_default['other'] = {'you' =>0.8,'yellow' =>0.9,'qingdu'=>0.90,'zhong'=>1.01,'zhongdu'=>1.34,'yanzhong'=>1.51}
	return cities_default
end

#25km缺省值写入哈希，此处为方便计算
def default_25km
	cities_default=Hash.new
	city_index = station_ext()

	#begin 长江口
	changjiangkou = {'you'=>0.9,'yellow'=>0.8,'qingdu'=>0.58,'zhong'=>0.68,'zhongdu'=>0.68,'yanzhong'=>1.01}
	#行号减一为i值
	for e in (79..103)
		next if e == 93
		# puts e.to_s+' '+city_index[e]
		cities_default[city_index[e]] = changjiangkou
	end		
	#end 长江口
	#
	#begin 东北
	dongbei = {'you'=>0.8,'yellow'=>0.8,'qingdu'=>0.88,'zhong'=>0.88,'zhongdu'=>0.88,'yanzhong'=>1.01}
	for e in (44..79)
		next if e == 57
		next if e == 66
		cities_default[city_index[e]] = dongbei
		# puts e.to_s+' '+city_index[e]
	end		
	cities_default['shenyangshi'] = {'you' =>0.9,'yellow' =>0.9,'qingdu'=>0.98,'zhong'=>0.88,'zhongdu'=>0.88,'yanzhong'=>0.90}
	cities_default['changchunshi'] = {'you' =>0.9,'yellow' =>0.8,'qingdu'=>0.78,'zhong'=>0.88,'zhongdu'=>0.88,'yanzhong'=>0.90}
	cities_default['haerbinshi'] = {'you' =>0.9,'yellow' =>0.9,'qingdu'=>0.98,'zhong'=>0.88,'zhongdu'=>0.90,'yanzhong'=>0.90}
	#end 东北
	#
	#shangdongshen 山东
	shandongsheng = {'you' =>0.8,'yellow' =>0.68,'qingdu'=>0.82,'zhong'=>0.85,'zhongdu'=>0.85,'yanzhong'=>0.75 }
	cities_default['jinanshi'] = {'you' =>0.9,'yellow' =>0.91,'qingdu'=>0.7,'zhong'=>0.85,'zhongdu'=>0.95,'yanzhong'=>0.85 }
	# for e in (142..157)
		# next if e == 57
		# next if e == 66
		# cities_default[city_index[e]] = shandongsheng
		puts e.to_s+' '+city_index[e]
	# end	
	 cities_default['dezhoushi'] = shandongsheng
	 cities_default['linyishi'] = shandongsheng
	 cities_default['rizhaoshi'] = shandongsheng
	 cities_default['binzhoushi'] = shandongsheng
	 cities_default['dongyingshi'] = shandongsheng
	 cities_default['shouguangshi'] = shandongsheng
	 cities_default['zhangqiushi'] = shandongsheng
	 cities_default['weifangshi'] = shandongsheng
	 cities_default['ziboshi'] = shandongsheng
	 cities_default['liaochengshi'] = shandongsheng
	 cities_default['hezeshi'] = shandongsheng
	 cities_default['zaozhuangshi'] = shandongsheng
	 cities_default['binzhoushi'] = shandongsheng
	 cities_default['weifangshi'] = shandongsheng
	 cities_default['dongyingshi'] = shandongsheng
	#end 
	#
	#hebeisheng not used 
	hengshuishi = {'you' =>1,'yellow' =>1,'qingdu'=>1.08,'zhong'=>0.79,'zhongdu'=>0.75,'yanzhong'=>0.85 }
	cities_default['hengshuishi'] = hengshuishi
	cities_default['handanshi']=hengshuishi
	cities_default['shijiazhuangshi'] = hengshuishi
	cities_default['xingtaishi'] = hengshuishi
	cities_default['tangshanshi'] = hengshuishi
	# cities_default['chengdeshi'] = hengshuishi
	cities_default['cangzhoushi'] = hengshuishi
	cities_default['tianjinshi'] = hengshuishi
	# cities_default['qinhuangdaoshi'] = hengshuishi
	# cities_default['zhangjiakoushi'] = hengshuishi
	cities_default['baodingshi'] = {'you' =>0.58,'yellow' => 0.88,'qingdu'=>1.05,'zhong'=>0.75,'zhongdu'=>0.75,'yanzhong'=>0.85 }
	cities_default['langfangshi'] = {'you' =>0.6,'yellow' =>0.75,'qingdu'=>1,'zhong'=>0.75,'zhongdu'=>0.75,'yanzhong'=>0.95 }
	#end
	#
	#henansheng 河南
	hennansheng = {'you' =>0.8,'yellow' =>0.65,'qingdu'=>0.69,'zhong'=>0.78,'zhongdu'=>0.85,'yanzhong' => 1.05}
	cities_default['zhengzhoushi'] = {'you' =>0.8,'yellow' =>1,'qingdu'=>1,'zhong'=>1.18,'zhongdu'=>1.15,'yanzhong' => 1.25}
	for e in (159..174)
		# next if e == 57
		# next if e == 66
		cities_default[city_index[e]] = hennansheng
		# puts e.to_s+' '+city_index[e]
	end	
	# cities_default['kaifengshi'] = hennansheng
	# cities_default['luoyangshi'] = hennansheng
	# cities_default['pingdingshanshi'] = hennansheng
	# cities_default['anyangshi'] = hennansheng
	# cities_default['hebeishi'] = hennansheng
	# cities_default['xinxiangshi'] = hennansheng
	# cities_default['jiaozuoshi'] = hennansheng
	# cities_default['puyangshi'] = hennansheng
	# cities_default['xuchangshi'] = hennansheng
	# cities_default['luoheshi'] = hennansheng
	# cities_default['sanmenxiashi'] = hennansheng
	# cities_default['nanyangshi'] = hennansheng
	# cities_default['shangqiushi'] = hennansheng
	# cities_default['xinyangshi'] = hennansheng
	# cities_default['zhoukoushi'] = hennansheng
	# cities_default['zhumadianshi'] = hennansheng
	#end
	#
	#hubeisheng 湖北
	hubeisheng = {'you' =>0.8,'yellow' =>1,'qingdu'=>1.08,'zhong'=>1.48,'zhongdu'=>1.78,'yanzhong'=>1.8}
	cities_default['wuhanshi'] = {'you' =>0.8,'yellow' =>1,'qingdu'=>1.08,'zhong'=>1.38,'zhongdu'=>1.58,'yanzhong'=>1.65}
	cities_default['huangshishi'] = hubeisheng
	cities_default['xiaoganshi'] = hubeisheng
	cities_default['jingmenshi'] = hubeisheng
	cities_default['huanggangshi'] = hubeisheng
	cities_default['shiyanshi'] = hubeisheng
	cities_default['ezhoushi'] = hubeisheng
	cities_default['jingzhoushi'] = hubeisheng
	#end
	cities_default['hangzhoushi'] = {'you' =>0.9,'yellow' =>1.0,'qingdu'=>1.25,'zhong'=>1.08,'zhongdu'=>1.18,'yanzhong'=>1.35}
	cities_default['zhengzhoushi'] = {'you' =>0.8,'yellow' =>1,'qingdu'=>1,'zhong'=>1.28,'zhongdu'=>1.35,'yanzhong' => 1.55}
	cities_default['hetiandiqu'] = {'you' => 0.5,'yellow' =>0.68,'qingdu'=>0.68,'zhong'=>1.08,'zhongdu'=>1.1,'yanzhong'=>1.1}
	cities_default['wulumuqi'] = {'you' => 0.2,'yellow' =>0.18,'qingdu'=>0.18,'zhong'=>1.08,'zhongdu'=>1.1,'yanzhong'=>1.1}
	cities_default['xianshi'] = {'you' => 0.9,'yellow' =>0.98,'qingdu'=>1.28,'zhong'=>1.78,'zhongdu'=>1.98,'yanzhong'=>2.11}
	cities_default['kashidiqu'] = cities_default['hetiandiqu'] 
	cities_default['guangzhoushi'] = {'you' =>0.6,'yellow' =>0.8,'qingdu'=>1.08,'zhong'=>1.38,'zhongdu'=>1.48,'yanzhong'=>1.5}
	cities_default['other'] = {'you' =>0.8,'yellow' =>1,'qingdu'=>1.58,'zhong'=>1.68,'zhongdu'=>1.58,'yanzhong'=>1.5}
	return cities_default
end
#遍历station
def station_ext
	firstline = true
	city = Array.new
	IO.foreach("vendor/station.EXT") do |line|
		if firstline
			city << line
			next
		end
		post_number = line[1,7]
		latitude = line[8,8]
		longitude = line[16,8]
		city_name_pinyin = line[25,18].strip
		city << city_name_pinyin
	end
	return city
end
