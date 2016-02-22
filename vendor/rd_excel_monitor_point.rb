Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet.open('vendor/monitor_point.xls')
sheet = book.worksheet(0)

firstLine=true
sheet.each do |row|
	if firstLine
		firstLine=false
		next
	end
	cityname=row[0].to_s.strip
	region=row[1].to_s.strip
	pointname=row[2].to_s.strip
	level=row[3].to_s.strip
	latitude=row[4]
	longitude=row[5]

	break if cityname == ''

	c = City.find_by_city_name(cityname)
	t=MonitorPoint.find_or_create_by(city_id: c.id, pointname: pointname)
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
