#!/usr/bin/env ruby
#
# rd_excel_city_info.rb
# Copyright (C) 2016 lbx <lbx@baoxi-PC>
#
# Distributed under terms of the MIT license.
#
Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet.open('vendor/city_info.xls')
sheet = book.worksheet(0)

firstLine=true
sheet.each do |row|
	if firstLine
		firstLine=false
		next
	end
	cityid=row[0]
	city_name=row[3].to_s.strip

	city=City.find_by_city_name(city_name)

	next if city.nil?
	city.cityid=cityid
	city.save
end
