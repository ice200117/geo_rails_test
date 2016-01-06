#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/vagrant/MeteoInfo/:/home/vagrant/.rbenv/shims/
# echo 'download 25km data figure'
# cd /vagrant/script/
# /vagrant/MeteoInfo/meteoinfo.sh post_download_25km_orig.py > ../log_orig.txt

echo 'run fix 25km'
cd /vagrant/geo_rails_test/
/home/vagrant/.rbenv/shims/rails r vendor/fore_fix/fore_fix_25km.rb -e production
