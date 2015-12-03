#!/bin/bash
# echo 'download 25km data figure'
# cd /vagrant/script/
# /vagrant/MeteoInfo/meteoinfo.sh post_download_25km_orig.py > ../log_orig.txt

echo 'run fix 25km'
cd /vagrant/geo_rails_test/
rails  r vendor/fore_fix/fore_fix_25km.rb 
