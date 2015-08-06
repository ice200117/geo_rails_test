# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "/vagrant/geo_rails_test/cron_log.log"
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
every "20 * * * * " do
	command "cd /vagrant/geo_rails_test/ && /home/vagrant/.rbenv/shims/rails r vendor/getdata/gethourdata.rb -e production"
end
every 1.days,:at=>'1:00 am' do
	command "cd /vagrant/geo_rails_test/ && /home/vagrant/.rbenv/shims/rails r vendor/getdata/getrank.rb -e production"
end
every 1.days,:at=>'1:30 am' do
	command "cd /vagrant/geo_rails_test/ && /home/vagrant/.rbenv/shims/rails r vendor/getdata/get74city_month_year.rb production"
end
