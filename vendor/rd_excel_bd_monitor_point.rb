Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet.open('vendor/bd_monitor_point.xls')
sheet = book.worksheet(0)

city = City.find_by_city_name('保定市')
firstLine=true
sheet.each do |row|
	if firstLine
		firstLine=false
		next
	end
	region=row[1].to_s.strip
	pointname=row[2].to_s.strip
	level=row[3].to_s.strip
	latitude=row[4]
	longitude=row[5]

	t=MonitorPoint.new
	t.city_id = city.id
	t.region = region
	t.pointname = pointname
	t.level = level
	t.latitude = latitude
	t.longitude = longitude
	t.save
end
