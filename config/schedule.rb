# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end
every 1.hours do
	flag=false
	while flag
		command "cd /vagrant/geo_rails_test/vendor/getdata && rails r gethourdata.rb"
		t=TempLfHour.last
		if t.between?(Time.now.beginning_of_hour - 60*60,Time.now.end_of_hour - 60*60) 
			flag=true
		else
			flag = false
			sleep 60
		end
	end
end
every 1.days,:at=>'1:00 am' do
	flag=false
	while flag
		command "cd /vagrant/geo_rails_test/vendor/getdata && rails r getrancd /vagrant/geo_rails_test/vendor/getdata && rails r getrank.rb"
		t=TempLfDay.last
		if t.between?(Time.now.yesterday.beginning_of_day,Time.now.yesterday.end_of_day)
			flag=true
		else
			flag=false
			sleep 60*60
		end
	end
end
every 1.days,:at=>'1:30 am' do
	flag=false
	while flag
		command "cd /vagrant/geo_rails_test/vendor/getdata && rails r getrancd /vagrant/geo_rails_test/vendor/getdata && rails r get74city_month_year.rb"
		t=TempLfDay.last
		if t.between?(Time.now.yesterday.beginning_of_day,Time.now.yesterday.end_of_day)
			flag=true
		else
			flag=false
			sleep 60*60
		end
	end
end
