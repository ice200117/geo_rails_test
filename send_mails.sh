#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/vagrant/MeteoInfo/:/home/vagrant/.rbenv/shims/
#echo 'download data and figure'
#cd /vagrant/script/
#/vagrant/MeteoInfo/meteoinfo.sh post_download_orig.py > ../log_9km_orig.txt

echo 'Send Mails To liubin,zqq,handsome,lbx'
cd /vagrant/geo_rails_test/
/home/vagrant/.rbenv/shims/rails r vendor/send_mail.rb 
#rails  r vendor/fore_fix/fore_74_rank.rb

