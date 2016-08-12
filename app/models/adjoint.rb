class Adjoint

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
	include NumRu

  attr_accessor :whatever
  validates :whatever, :presence => true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def self.grid2polygon(point_data)
    @factory ||= RGeo::Geographic.spherical_factory(:srid => 4326)
    #@factory = RGeo::Geographic.simple_mercator_factory

    polygon_list = []
    point_data.each do |p|
      coordinates = [ [p[:lon]-0.05, p[:lat]-0.05], [p[:lon]-0.05, p[:lat]+0.05], [p[:lon]+0.05, p[:lat]+0.05], [p[:lon]+0.05, p[:lat]-0.05],[p[:lon]-0.05, p[:lat]-0.05] ]
      ring = @factory.line_string(coordinates.map { |(x, y)| @factory.point x, y })
      polygon_list << @factory.polygon(ring)
    end
    polygon_list

  end

  def self.get_color(val)
    case val
    when -1E+9..0.1
      "#79E6F0"
    when 0.1..0.2
      "#C8DC33"
    when 0.2..0.4
      "#F0DC16"
    when 0.4..0.6
      "#FFBE16"
    when 0.6..0.8
      "#FF790C"
    when 0.8..1.0
      "#FF5B0C"
    when 1.0..2.0
      "#F02A02"
    when 2.0..4.0
      "#B40C02"
    when 4.0..8.0
      "#790C02"
    else
      "#330C02"
    end
  end

  def self.to_feature(datum, polygon, i, var)
    scale = {"SO2"=> 50, "BC"=>1E-7 }
    scale_v = {"SO2"=> 1, "BC"=>1E-9 }
    @entity_factory ||= RGeo::GeoJSON::EntityFactory.instance
    @entity_factory.feature(polygon, i, :height => (datum[:percent]*scale[var]).to_s, :color=> get_color(datum[:percent]*scale_v[var]),
                            :roofColor=> get_color(datum[:percent]*scale_v[var]))
    #@entity_factory.feature(polygon, i, :height => datum[:percent], :color=>"rgb(255,0,0)")
  end

  def self.read_adj_nc(var, period)
    path = "#{Rails.root.to_s}/tmp/data/"
    # TODO, Find latest date of adj file.
	#path = 'public/images/ftproot/Temp/BackupADJ/'
    fname = "CUACE_09km_adj_2016-06-25.nc"
    ncfile =path + '/' + fname;
    var_name = "#{var}_#{period}"

		file = NetCDF.open(ncfile)
		# Get longitude
    data = file.var(var_name).get
    return nil if data.nil?
    lat = file.var('lat').get
    lon = file.var('lon').get
		sp = data.shape
    #puts sp
    tmp = 1
    tmp = 1E+9 if var=="BC"
    point_data = []
		for i in 0..sp[0]-1
		  for j in 0..sp[1]-1
        if data[i,j,0,0] > 0.1*tmp
          point_data << {lon: lon[i], lat: lat[j], percent: data[i,j,0,0]}
        end
      end
    end
    point_data
  end

  LF_ADJ_CITY = %w(唐山 邢台 邯郸 保定 北京 天津 衡水 沧州 廊坊 石家庄 秦皇岛 承德 张家口)
 
  def self.to_geojson(var='SO2', period='120')
    geo_feature_collection = []
    # Read nc, get var, period Data
    point_data = read_adj_nc var,period
    return nil if point_data.nil?
    # Get each city percent.
    perc = city_percent(point_data, LF_ADJ_CITY)
    # Create grid lat lon -> polygon.
    polygon_list = grid2polygon(point_data)
    # To feature , return geo_json

    polygon_list.each_with_index do |p,i|
      geo_feature_collection << to_feature(point_data[i], p, i, var)
    end
    [RGeo::GeoJSON.encode(@entity_factory.feature_collection(geo_feature_collection)), perc] 
  end

  def self.city_percent(point_data, city_list)
    perc = {}
    city_list.each { |c| perc[c] = 0.0 }
    sum = 0.0
    point_data.each do |p|
      region_name = Region.containing_latlon(p[:lat], p[:lon]).first.name
      sum = sum + p[:percent]
      city_list.each { |c| perc[c] = perc[c] + p[:percent] if region_name.index(c) }
    end
    qita = sum
    perc.each {|k,v| v>0 ? qita = qita - v : perc.delete(k) }
    perc["其他"] = qita if qita>0
    perc
  end

end
