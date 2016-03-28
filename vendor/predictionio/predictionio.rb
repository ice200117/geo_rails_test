#!/usr/bin/env ruby
require 'predictionio'
#
# predictionio.rb
# Copyright (C) 2016 libaoxi <693879111@qq.com>
#
# Distributed under terms of the MIT license.
#

ENV['PIO_THREADS']='50'
ENV['PIO_EVENT_SERVER_URL']='http://localhost:7070'
ENV['PIO_ACCESS_KEY']='p6TlzzBU6wUpoqmyzr7CatmhdZOevTbn0P9UfWMKI9gjMjNLRq5WKy'
client=PredictionIO::EventClient.new(ENV['PIO_ACCESS_KEY'],ENV['PIO_EVENT_SERVER_URL'],Integer(ENV['PIO_THREADS']))
client.create_event(
)
