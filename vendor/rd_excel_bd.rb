require_relative './bd_save_month_year.rb'

Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet.open('vendor/bd_data.xls')
sheet = book.worksheet(0)

firstLine=true
sheet.each do |row|
	if firstLine
		firstLine=false
		next
	end
	time=row[0]
	city_name=row[3].to_s.strip
	puts city_name
	aqi=row[4]
	pm25=row[5]
	pm10=row[6]
	so2=row[7]
	no2=row[8]
	o3=row[9]
	co=row[10]
	quality=row[11]
	primary_pol=row[12]

	city=City.find_by_city_name(city_name)

	break if city.nil?
	t=TempBdDay.new
	t.city_id = city.id
	t.data_real_time = time
	t.AQI = aqi
	t.pm25 = pm25
	t.pm10 = pm10
	t.SO2 = so2
	t.NO2 = no2
	t.O3 = o3
	t.CO = co
	t.level = quality
	t.main_pol = primary_pol
	t.save
	set_change_rate
end
