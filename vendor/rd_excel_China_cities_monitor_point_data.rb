Spreadsheet.client_encoding = 'UTF-8'

a=Array(201408..201412)
b=Array(201501..201509)
c=a+b
c.each do |filename|
	book = Spreadsheet.open("vendor/#{filename}.xls")
	sheet = book.worksheet(0)

	firstLine=true
	sheet.each do |row|
		if firstLine
			firstLine=false
			next
		end
		time = row[0].to_time
		cityname=row[1].to_s.strip
		pointname=row[2].to_s.strip
		aqi=row[3].to_i
		pm25=row[4].to_i
		pm10=row[5].to_i
		so2=row[6].to_i
		no2=row[7].to_i
		o3=row[8].to_i
		co=row[9].to_i*1000
		level=row[10].to_s.strip
		latitude=row[4]
		longitude=row[5]

		break if cityname == ''

		# c = City.find_by_city_name(cityname)
		t=MonitorPointHour.find_or_create_by(city_id: c.id, pointname: pointname)
		next if t.region
		puts cityname
		t.city_id = c.id
		t.region = region
		t.pointname = pointname
		t.level = level
		t.latitude = latitude
		t.longitude = longitude
		t.save
	end
end
