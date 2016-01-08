#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/vagrant/MeteoInfo/:/home/vagrant/.rbenv/shims/
cd /vagrant/geo_rails_test/
echo 'rank74'
#/home/vagrant/.rbenv/shims/rails r vendor/fore_fix/fore_74_rank.rb -e production

cd /vagrant/geo_rails_test/
echo 'send mails'
#/home/vagrant/.rbenv/shims/rails r vendor/fore_fix/test_send_mail.rb -e production
 rails  r vendor/fore_fix/test_send_mail.rb -e production
