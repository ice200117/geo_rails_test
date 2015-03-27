
cl = County.all
cl.each { |c| c.destroy }

require 'iconv'

arr = IO.readlines("vendor/2")
i = 0
mct_proj4 = '+proj=merc +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=6378137 +b=6378137 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs '
mct_wkt = <<WKT
WKT
mct_factory = RGeo::Geographic.simple_mercator_factory
#space_needle_latlon = RGeo::Feature.cast(space_needle, :factory => wgs84_factory, :project => true)

wgs84_proj4 = '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'
wgs84_wkt = <<WKT
  GEOGCS["WGS 84",
    DATUM["WGS_1984",
      SPHEROID["WGS 84",6378137,298.257223563,
        AUTHORITY["EPSG","7030"]],
      AUTHORITY["EPSG","6326"]],
    PRIMEM["Greenwich",0,
      AUTHORITY["EPSG","8901"]],
    UNIT["degree",0.01745329251994328,
      AUTHORITY["EPSG","9122"]],
    AUTHORITY["EPSG","4326"]]
WKT
factory = RGeo::Geographic.spherical_factory(:srid => 4326, :proj4 => wgs84_proj4, :coord_sys => wgs84_wkt)
RGeo::Shapefile::Reader.open('vendor/map/heibei.shp', :factory => County::FACTORY) do |file|
  file.each do |record|
    boundarys = record.geometry.projection
    # geom is now an RGeo geometry object.
    #name = record['NAME99']
    name = arr[i].chomp!
    i += 1
    puts name
    #name = Iconv.conv('cp936//IGNORE', 'utf-8//IGNORE', name)
    area = record['AREA']
    perimeter = record['PERIMETER']
    adcode = record['ADCODE99']
    centroid_y = record['CENTROID_Y']
    centroid_x = record['CENTROID_X']

    c = County.new
    c.name       =  name      
    c.area       =  area      
    c.perimeter  =  perimeter 
    c.adcode     =  adcode    
    c.centroid_y =  centroid_y
    c.centroid_x =  centroid_x
    #c.boundary   =  RGeo::Feature.cast(boundarys, :factory => mct_factory, :project => true)
    c.boundary   =  boundarys
    c.save 
  end
end
