def post_rank_json(webUrl,secretstr,typestr,datestr='')
  begin
    option = {secret:secretstr,type:typestr,date:datestr,key:Digest::MD5.hexdigest(secretstr+typestr+datestr) }
    response = HTTParty.post('http://www.izhenqi.cn/api/getrank.php', :body => option)
    json_data=JSON.parse(response.body)
    puts json_data
    hs = Hash.new
    hs[:time] =json_data['time']
    hs[:cities] = json_data['rows']
  rescue
    puts 'Can not get data from izhenqi, please check network!'
  end 
end


def get_rank_json(datestr)
  puts datestr
  begin
    response = HTTParty.get('http://115.28.227.231:8082/api/data/day-qxday?date='+datestr)
    json_data=JSON.parse(response.body)
    puts json_data
  rescue
    puts 'Can not get data from izhenqi, please check network!'
  end 
end

#post_rank_json('','LANGFANGRANK','DAY')
#post_rank_json('','CHINARANK','DAY')
#post_rank_json('','HEBEIRANK','DAY')
get_rank_json(Time.new(2014,5,30).strftime("%Y-%m-%d"))

