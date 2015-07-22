#def post_rank_json(webUrl,secretstr,typestr,datestr)
def post_rank_json(secretstr,typestr,datestr='')
  begin
    if datestr.length > 0
    option = {secret:secretstr,type:typestr,date:datestr,key:Digest::MD5.hexdigest(secretstr+typestr+datestr) }
    response = HTTParty.post('http://www.izhenqi.cn/api/getrank.php', :body => option)
    else
    option = {secret:secretstr,type:typestr,key:Digest::MD5.hexdigest(secretstr+typestr) }
    response = HTTParty.post('http://www.izhenqi.cn/api/getdata_cityrank.php', :body => option)
    end
    json_data=JSON.parse(response.body)
    puts json_data
    hs = Hash.new
    hs[:time] =json_data['time']
    hs[:cities] = json_data['rows']
  rescue
    puts 'Can not get data from izhenqi, please check network!'
  end 
end


def get_rank_json(date)
  datestr = date.strftime("%Y-%m-%d")
  begin
    response = HTTParty.get('http://115.28.227.231:8082/api/data/day-qxday?date='+datestr)
    json_data=JSON.parse(response.body)
    puts json_data
    dc = DayCity.new

  rescue
    puts 'Can not get data from izhenqi, please check network!'
  end 
end

#post_rank_json('','LANGFANGRANK','DAY')
post_rank_json('CHINARANK','DAY')
#post_rank_json('','HEBEIRANK','DAY')

#oneday = 60*60*24
#stime = Time.new(2015,6,1)
#etime = Time.new(2015,6,2)
#while stime<=etime
  #get_rank_json(stime)
  #puts '==============================================='
  #stime = stime + oneday
#end
