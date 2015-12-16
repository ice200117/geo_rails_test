require 'net/smtp'

filename = "/vagrant/city.txt"
filecontent = File.read(filename)
encodedcontent = filecontent

marker = 'AUNIQUEMARKER'

body =<<EOF
This is a test email to send an attachment.
EOF

part1 =<<EOF
Form: libaoxi <libaoxi@hh12369.com>
To: <693879111@qq.com>
Subject: Cities
MIME-Version: 1.0
Content-Type: multipart/mixed;buoundary=#{marker}
--#{marker}
EOF

part2 =<<EOF
Content-Type: text/plain
Content-Transfer-Encodeing:8bit

#{body}
--#{marker}
EOF

part3 =<<EOF
Content-Type: multipart/mixed;name=\"#{filename}\"
Content-Transfer-Encodeing:base64
Content-Disposition: attachment;filename="#{filename}"

#{encodedcontent}
--#{marker}--
EOF

mailtext = part1+part2+part3

# response = HTTParty.get("http://60.10.135.153:3000/bar.json")
# data = JSON.parse(response.body)
# data.delete_if{|x| x[3]<49}

# message = <<MESSAGE_END

# {data}
# MESSAGE_END

Net::SMTP.start('smtp.mxhichina.com',25,'hh12369.com','libaoxi@hh12369.com','Lbx12369@',:plain) do |smtp|
	open_timeout=(300)
	read_timeout=(300)
	smtp.sendmail(mailtext,'libaoxi@hh12369.com',['693879111@qq.com'])
end
