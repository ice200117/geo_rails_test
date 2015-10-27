uid = 'TEST02434'
passwd = '123456'
telphone = '18210515093'
message = '短信平台测试'
response = HTTParty.get(URI.escape("http://api.bjszrk.com/sdk/BatchSend.aspx?CorpID=#{uid}&Pwd=#{passwd}&Mobile=#{telphone}&Content=#{message}&Cell=&SendTime="))
puts response

