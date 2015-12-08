require 'net/smtp'

response = HTTParty.get("http://60.10.135.153:3000/bar.json")
data = JSON.parse(response.body)
data.delete_if{|x| x[3]<49}

message = <<MESSAGE_END
Form: libaoxi <libaoxi@hh12369.com>
To: [libaoxi <693879111@qq.com>,libaoxi <libaoxi0817@qq.com>]
Subject: Cities

#{data}
MESSAGE_END

Net::SMTP.start('smtp.mxhichina.com',25,'hh12369.com','libaoxi@hh12369.com','Lbx12369@',:plain) do |smtp|
	smtp.send_message(message,'libaoxi@hh12369.com',['693879111@qq.com','libaoxi0817@qq.com'])
	# smtp.send_message(message,'libaoxi@hh12369.com','libaoxi0817@qq.com')
	# smtp.send_message(message,'libaoxi@hh12369.com','libaoxi@hh12369.com')
end
