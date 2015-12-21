#!/bin/bash

cd /vagrant/geo_rails_test/
echo 'rank74'
# rails  r vendor/fore_fix/fore_74_rank.rb 
 rails  r vendor/fore_fix/fore_74_rank.rb -e production

echo 'send mails'
rails  r vendor/fore_fix/test_send_mail.rb -e production
