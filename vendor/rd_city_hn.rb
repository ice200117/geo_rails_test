firstline = true
hb_city = Array.new
IO.foreach("vendor/station.EXT") do |line| 
  if firstline
    firstline = false
    next
  end
  post_number = line[1,7]
  latitude = line[8,8].to_f
  longitude = line[16,8].to_f
  city_name_pinyin = line[25,18].strip
  if latitude >= 30 and latitude <=40 and
	 longitude >= 106 and longitude <=122
	  puts line
  end
  #hb_city << city_name_pinyin
#  city_name  = line[46..-4].strip
end

if hb_city.include?('langfangshi') 
  #puts 'in'
end
