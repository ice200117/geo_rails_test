# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
cities = City.create([{city_name: "安国市", city_name_pinyin: "anguoshi", post_number: 130683, latitude: 38.424, longitude: 115.333 }, { city_name: "清苑县", city_name_pinyin: "qingyuanxian", post_number: 130622, latitude: 38.771, longitude: 115.496}])
