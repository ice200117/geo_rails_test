#!/usr/bin/env ruby
#
# week.rb
# Copyright (C) 2016 vagrant <vagrant@vagrant-ubuntu-trusty-64>
#
# Distributed under terms of the MIT license.
#

module Custom::Week
	def self.week_of_time(time)
		day=time.strftime("%w")
		if day=='0'
			day='日'
		elsif day=='1'
			day='一'
		elsif day=='2'
			day='二'
		elsif day=='3'
			day='三'
		elsif day=='4'
			day='四'
		elsif day=='5'
			day='五'
		elsif day=='6'
			day='六'
		end
	end
end
