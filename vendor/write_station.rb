module WriteStation
	
end
city_name_encode = ERB::Util.url_encode(city_name)
options = Hash.new
headers={'apikey' => 'f8484c1661a905c5ca470b0d90af8d9f'}
options[:headers] = headers
url = "http://apis.baidu.com/showapi_open_bus/weather_showapi/address?area=#{city_name_encode}&needMoreDay=1"
response = HTTParty.get(url,options)
json = JSON.parse(response.body)
puts 0 if json['showapi_res_error'] == 0
weather = Array.new
json['showapi_res_body'].each do |k,v|
	weather << get_tq(v) if k[-1].to_i > 0
end
