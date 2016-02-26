firstline = true
hb_city = Array.new
#IO.foreach("vendor/station_hb.EXT") do |line| 
IO.foreach("vendor/station.EXT") do |line| 
  if firstline
    firstline = false
    next
  end
  post_number = line[1,7]
  latitude = line[8,8].to_f
  longitude = line[16,8].to_f
  city_name_pinyin = line[25,18].strip
  hb_city << city_name_pinyin
  if latitude >= 34 and latitude <=44 and
	 longitude >= 108 and longitude <=123
	  puts line
  end
#  city_name  = line[46..-4].strip
end

if hb_city.include?('langfangshi') 
  puts 'in'
end
