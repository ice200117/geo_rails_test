#!/bin/bash
# PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/vagrant/MeteoInfo/:/home/vagrant/.rbenv/shims/
# cd /vagrant/script/
# /vagrant/MeteoInfo/meteoinfo.sh post_download_orig.py > ../log_9km_orig.txt

cd /vagrant/geo_rails_test/
rails  r vendor/fore_fix/fore_fix_9km.rb 
