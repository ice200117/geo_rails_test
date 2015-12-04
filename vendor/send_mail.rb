require 'net/smtp'



message = <<MESSAGE_END
Form: libaoxi<libaoxi@hh12369.com>
To: libaoxi<693879111@qq.com>
Subject: City Message 

#{msg_body}
MESSAGE_END

Net::SMTP.start('smtp.mxhichina.com',25,'hh12369.com','libaoxi@hh12369.com','Lbx12369@',:plain) do |smtp|
	smtp.send_message(message,'libaoxi@hh12369.com','liubin@hh12369')
	smtp.send_message(message,'libaoxi@hh12369.com','zhouqinqian@hh12369.com')
	smtp.send_message(message,'libaoxi@hh12369.com','lihaishan@hh12369.com')
	smtp.send_message(message,'libaoxi@hh12369.com','libaoxi@hh12369.com')
end
