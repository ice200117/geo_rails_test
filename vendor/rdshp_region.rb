
cl = Region.all
cl.each { |c| c.destroy }

require 'iconv'

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
w_factory = RGeo::Geographic.spherical_factory(:srid => 4326, :proj4 => wgs84_proj4, :coord_sys => wgs84_wkt)
RGeo::Shapefile::Reader.open('vendor/map/poly_region.shp', :factory => Region::FACTORY) do |file|
  file.each do |record|
    name = record['NAME']
    area = record['AREA']
    perimeter = record['PERIMETER']
    name = Iconv.conv('UTF-8//IGNORE', 'GB2312//IGNORE', name)
    if name=="廊房市" or name=="三河市"
      name="廊坊市"
    end
    puts name

    r = Region.new
    r.name       =  name      
    r.area       =  area      
    r.perimeter  =  perimeter 


    #boundarys = record.geometry.projection
    #record.geometry.projection.each do |poly|
      #byebug
      #County.create(:name => name, :area => area, :perimeter => perimeter, :adcode => adcode, :centroid_y => centroid_y, :centroid_x => centroid_x, :boundary => poly)
    #end

    #geom   =  RGeo::Feature.cast(record.geometry.projection, :factory => Region::FACTORY, :project => true)
    geom = record.geometry.projection
    # geom is now an RGeo geometry object.
    r.boundary   =  geom
    r.save 
  end
end
