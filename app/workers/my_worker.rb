#!/usr/bin/env ruby
#
# my_worker.rb
# Copyright (C) 2016 libaoxi <693879111@qq.com>
#
# Distributed under terms of the MIT license.
#


class HardWorker
    include Sidekiq::Worker
    def perform(name,count)
        (0..count).each{|x| puts name}
    end
end
