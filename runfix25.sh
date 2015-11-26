#!/bin/bash

#cd /vagrant/script/
#/vagrant/MeteoInfo/meteoinfo.sh post_download_25km_orig.py > ../log_orig.txt

cd /vagrant/geo_rails_test/
rails  r vendor/fore_fix/fore_fix_25km.rb 
