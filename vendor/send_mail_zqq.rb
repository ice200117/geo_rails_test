require 'net/smtp'

response = HTTParty.get("http://60.10.135.153:3000/bar.json")
data = JSON.parse(response.body)
data.delete_if{|x| x[3]<49}

message = <<MESSAGE_END
Form: zhouqinqian <zhouqinqian@hh12369.com>
To: <zqq0ew0@163.com>
Subject: Cities

#{data}
MESSAGE_END

Net::SMTP.start('smtp.mxhichina.com',25,'hh12369.com','zhouqinqian@hh12369.com','zqq123456!',:plain) do |smtp|
	open_timeout=(300)
	read_timeout=(300)
	smtp.send_message(message,'zhouqinqian@hh12369.com',['zqq0ew0@163.com'])
end
