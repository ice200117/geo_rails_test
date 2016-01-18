require 'net/smtp'
require 'rubygems'
require 'mailfactory'

response = HTTParty.get("http://60.10.135.153:3000/bar.json")
data = JSON.parse(response.body)
data.delete_if{|x| x[3]<49}

mail = MailFactory.new()
mail.to = ['693879111@qq.com','liubin@hh12369.com','zhouqinqian@hh12369.com','handsomelhs2@163.com']
mail.from = 'libaoxi@hh12369.com'
mail.subject = '差值超过50的城市'
mail.text = "#{data}"

Net::SMTP.start('smtp.mxhichina.com',25,'mail.hh12369.com','libaoxi@hh12369.com','Lbx12369@',:plain) do |smtp|
	open_timeout=(300)
	read_timeout=(300)
	smtp.send_message(mail.to_s,'libaoxi@hh12369.com',['693879111@qq.com','liubin@hh12369.com','zhouqinqian@hh12369.com','handsomelhs2@163.com'])
end
