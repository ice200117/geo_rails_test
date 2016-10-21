def input
	error_file = './vendor/insert_enterprise_countyid_production_error.txt'
	f = File.open(error_file,'w')
	Enterprise.all.each do |e|
		latitude=e.latitude
		longitude=e.longitude
		county=County.containing_latlon(latitude,longitude)
		if county[0].nil?
			f.puts('找不到 '+e.en_name+':'+e.id.to_s+' 对应的区县！')
		else
			result=e.update(county_id: county[0].id)
			if result
				puts e.en_name+':'+e.id.to_s+' '+'county_id update ok!'
			else
				f.puts(e.en_name+':'+e.id.to_s+' '+'county_id update error!')
			end
		end
	end
end
input
