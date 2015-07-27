firstline = true
hb_city = Array.new
IO.foreach("vendor/station_hb.EXT") do |line| 
  if firstline
    firstline = false
    next
  end
  post_number = line[1,7]
  latitude = line[8,8]
  longitude = line[16,8]
  city_name_pinyin = line[25,18].strip
  hb_city << city_name_pinyin
#  city_name  = line[46..-4].strip
end

if hb_city.include?('langfangshi') 
  puts 'in'
end
