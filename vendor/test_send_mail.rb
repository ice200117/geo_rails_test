require 'net/smtp'

filename = "/vagrant/city.txt"

# 定义主要的头部信息
part1 =<<MESSAGE_END
From: Private Person <libaoxi@hh12369.com>
To: A Test User <693879111@qq.com>
Subject: Sending Attachement
MIME-Version: 1.0
Content-Type: text/plain
Content-Type: multipart/mixed; name=\"#{filename}\"
Content-Disposition: attachment; filename="#{filename}"

asdfasdfasdf
MESSAGE_END

# 发送邮件
Net::SMTP.start('smtp.mxhichina.com',25,'hh12369.com','libaoxi@hh12369.com','Lbx12369@',:plain) do |smtp|
	open_timeout=(300)
	read_timeout=(300)
	smtp.sendmail(mailtext, 'libaoxi@hh12369.com',
				  ['693879111@qq.com'])
end
