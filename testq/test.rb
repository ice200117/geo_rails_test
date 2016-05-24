#!/usr/bin/env ruby
#
# test.rb
# Copyright (C) 2016 libaoxi <693879111@qq.com>
#
# Distributed under terms of the MIT license.
#

def test
	hs=Hash.new
	hs[:secret] = '70ad4cb02984355c0f08f2e84be72c9c'
	hs[:method] = 'GETPROVINCESTATIONDATA'
	hs[:type] = 'HOUR'
	hs[:key]=Digest::MD5.hexdigest(hs[:secret]+hs[:method]+hs[:type])

	byebug
	response = HTTParty.post('http://www.izhenqi.cn/api/dataapi.php', :body => hs)
	data=JSON.parse(Base64.decode64(response.body))
	# data=JSON.parse(Base64.decode64(Base64.decode64(Base64.decode64(response.body))))
	f = File.open('/vagrant/geo_rails_qhd/test.txt','w')
	f.puts(data)
	f.close
end
test
