class ForecastPoint < ActiveRecord::Base
  before_save       :setLonLat

  set_rgeo_factory_for_column(:latlon,
    RGeo::Geographic.spherical_factory(:srid => 4326))

  def setLonLat
    self.latlon = "POINT(#{longitude} #{latitude})"
  end

  def nearest_latlon(lon, lat)
    #ps = ForecastPoint.where("ST_Distance(latlon, "+
                   #"'POINT(#{lon} #{lat})') < 150000")
  end

  def lookup(date)
    o = []
    name1 = '环境监测监理中心'
    lat1 = 39.5564
    lon1 = 116.715127
    name2 = '北华航天学院'
    lon2 = 116.738807
    lat2 = 39.534095
    name3 = '开发区'
    lat3 = 39.574829
    lon3 = 116.772741
    name4 = '药材公司'
    lat4 = 39.518101
    lon4 = 116.683974
    ps = [{name: name1, lon: lon1, lat: lat1},
          {name: name2, lon: lon2, lat: lat2},
          {name: name3, lon: lon3, lat: lat3},
          {name: name4, lon: lon4, lat: lat4},
          {name: '保定',lon: 115.48, lat: 38.85}
    ]

    fps = ForecastPoint.all
    ps.each {|p|
      ql = []
      lon = p[:lon]
      lat = p[:lat]
      fps.each { |fp|
        if lon > fp.longitude-0.05 && lon < fp.longitude+0.05 \
          && lat >fp.latitude-0.05 && lat < fp.latitude+0.05
          ql << fp
        end
      }
      ql.each { |q|
        if date != "" 
          if date == q.publish_date.strftime("%Y%m%d")
            o << {name: p[:name], lon: q.longitude, lat: q.latitude, aqi: q.AQI, publish_date: q.publish_date.strftime("%Y-%m-%d %H:%M:%S"), forecast_date: q.forecast_date.strftime("%Y-%m-%d %H:%M:%S")}
          end
        else
          o << {name: p[:name], lon: q.longitude, lat: q.latitude, aqi: q.AQI, publish_date: q.publish_date.strftime("%Y-%m-%d %H:%M:%S"), forecast_date: q.forecast_date.strftime("%Y-%m-%d %H:%M:%S")}
        end
      }   
    }
    o
  end
end
