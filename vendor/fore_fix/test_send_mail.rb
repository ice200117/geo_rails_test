require 'net/smtp'
require 'rubygems'
require 'mailfactory'

strtime = Time.now.strftime("%Y%m%d")
time = strtime.to_time.yesterday.strftime("%Y%m%d")+'20'
puts strtime

filename = Time.now.strftime("%Y%m%d").to_s+'.txt'
puts filename
path = "/mnt/share/Temp/station_9km/#{strtime[0,8]}/"
fn = "XJ_ENVAQFC_langfangshi_#{time}_00000-07200.TXT"
puts path+fn

mail = MailFactory.new()
mail.to = 'wangyanchao@hh12369.com','libaoxi@hh12369.com'
mail.from = 'libaoxi@hh12369.com'
mail.subject = 'Rank'
#mail.attach("/mnt/share/Temp/Rank/city.txt")
#mail.attach("/mnt/share/Temp/Rank/20151215.txt")
if File.exists?("/mnt/share/Temp/Rank/#{filename}")
	mail.attach("/mnt/share/Temp/Rank/#{filename}")
# else if File.exists?(path+fn)
	mail.attach(path+fn) if File.exist?(path+fn)
else
	mail.text = "#{filename} is null!"
end
Net::SMTP.start('smtp.mxhichina.com',25,'mail.hh12369.com','libaoxi@hh12369.com','Lbx12369@',:plain) do |smtp|
	# mail.to = toaddress
	open_timeout=(300)
	read_timeout=(300)
	smtp.sendmail(mail.to_s, 'libaoxi@hh12369.com',
				  'wangyanchao@hh12369.com','libaoxi@hh12369.com')
end
