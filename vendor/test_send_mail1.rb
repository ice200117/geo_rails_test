require 'net/smtp'
require 'rubygems'
require 'mailfactory'

mail = MailFactory.new()
mail.to = ['693879111@qq.com']
mail.from = 'libaoxi@hh12369.com'
mail.subject = 'test'
mail.attach("/vagrant/city.txt")
Net::SMTP.start('smtp.mxhichina.com',25,'mail.hh12369.com','libaoxi@hh12369.com','Lbx12369@',:plain) do |smtp|
	# mail.to = toaddress
	open_timeout=(300)
	read_timeout=(300)
	smtp.sendmail(mail.to_s, 'libaoxi@hh12369.com',
				  ['693879111@qq.com'])
end
