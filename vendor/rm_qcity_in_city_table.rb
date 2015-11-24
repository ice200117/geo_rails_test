#!/usr/bin/ruby

IO.foreach("vendor/rm_qcity_in_city_table.EXT") do |line|
	city_name_pinyin = line[25,18].to_s.strip
	next if City.find_by_city_name_pinyin(city_name_pinyin) == nil
	p city_name_pinyin
	c=City.find_by_city_name_pinyin(city_name_pinyin).delete
end
