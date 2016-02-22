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
every "10 */1 * * *" do
	command "cd /vagrant/geo_rails_test/ && /home/vagrant/.rbenv/shims/rails r vendor/getdata/gethourdata_of_qinhuangdao.rb -e development"
end
