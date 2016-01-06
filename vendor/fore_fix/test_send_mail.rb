require 'net/smtp'
require 'rubygems'
require 'mailfactory'

strtime = Time.now.strftime("%Y%m%d")
puts strtime
filename = Time.now.strftime("%Y%m%d").to_s+'.txt'
puts filename

mail = MailFactory.new()
mail.to = 'wangyanchao@hh12369.com','zhouqinqian@hh12369.com'
mail.from = 'libaoxi@hh12369.com'
mail.subject = 'Rank'
#mail.attach("/mnt/share/Temp/Rank/city.txt")
#mail.attach("/mnt/share/Temp/Rank/20151215.txt")
if File.exists?("/mnt/share/Temp/Rank/#{filename}")
	mail.attach("/mnt/share/Temp/Rank/#{filename}")
else
	mail.text = "#{filename} is null!"
end
Net::SMTP.start('smtp.mxhichina.com',25,'mail.hh12369.com','libaoxi@hh12369.com','Lbx12369@',:plain) do |smtp|
	# mail.to = toaddress
	open_timeout=(300)
	read_timeout=(300)
	smtp.sendmail(mail.to_s, 'libaoxi@hh12369.com',
				  'wangyanchao@hh12369.com','zhouqinqian@hh12369.com')
end
