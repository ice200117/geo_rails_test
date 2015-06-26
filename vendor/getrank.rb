def get_rank_json(webUrl,secretstr,typestr,datestr='')
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

get_rank_json('','LANGFANGRANK','DAY')
