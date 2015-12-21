require 'net/smtp'

response = HTTParty.get("http://60.10.135.153:3000/bar.json")
data = JSON.parse(response.body)
data.delete_if{|x| x[3]<49}

message = <<MESSAGE_END
Form: libaoxi <libaoxi@hh12369.com>
To: <693879111@qq.com>,<liubin@hh12369.com>,<zhouqinqian@hh12369.com>,<lihaishan@hh12369.com>
Subject: Cities

#{data}
MESSAGE_END

Net::SMTP.start('smtp.mxhichina.com',25,'mail.hh12369.com','libaoxi@hh12369.com','Lbx12369@',:plain) do |smtp|
	open_timeout=(300)
	read_timeout=(300)
	smtp.send_message(message,'libaoxi@hh12369.com',['693879111@qq.com','liubin@hh12369.com','zhouqinqian@hh12369.com','lihaishan@hh12369.com'])
end
