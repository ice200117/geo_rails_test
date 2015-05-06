class County < ActiveRecord::Base
  # Create a simple mercator factory. This factory itself is
  # geographic (latitude-longitude) but it also contains a
  # companion projection factory that uses EPSG 3785.
  FACTORY = RGeo::Geographic.simple_mercator_factory
  station1 = {:name => "环境监测监理中心", :lon => 116.715127, :lat => 39.5564   }
  station2 = {:name => "北华航天学院",     :lon => 116.73880,  :lat => 39.534095 }
  station3 = {:name => "开发区",           :lon => 116.772741, :lat => 39.574829 }
  station4 = {:name => "药材公司",         :lon => 116.68397,  :lat => 39.518101 }
  stations = [station1, station2, station3, station4]

  # We're storing data in the database in the projection.
  # So data gotten straight from the "boundary" attribute will be in
  # projected coordinates.
  set_rgeo_factory_for_column(:boundary, FACTORY.projection_factory)

  # To interact in projected coordinates, just use the "boundary"
  # attribute directly.
  def boundary_projected
    self.boundary
  end
  def boundary_projected=(value)
    self.boundary = value
  end

  # To use geographic (lat/lon) coordinates, convert them using
  # the wrapper factory.
  def boundary_geographic
    FACTORY.unproject(self.boundary)
  end
  def boundary_geographic=(value)
    self.boundary = FACTORY.project(value)
  end

  # w,s,e,n are in latitude-longitude
  def self.in_rect(w, s, e, n)
    # Create lat-lon points, and then get the projections.
    sw = FACTORY.point(w, s).projection
    ne = FACTORY.point(e, n).projection
    # Now we can create a scope for this query.
    where("boundary && '#{sw.x},#{sw.y},#{ne.x},#{ne.y}'::box")
  end

  EWKB = RGeo::WKRep::WKBGenerator.new(:type_format => :ewkb,
                                       :emit_ewkb_srid => true, :hex_format => true)
  def self.containing_latlon(lat, lon)
    ewkb = EWKB.generate(FACTORY.point(lon, lat).projection)
    where("ST_Intersects(boundary, ST_GeomFromEWKB(E'\\\\x#{ewkb}'))")
  end

  def self.containing_geom(geom)
    ewkb = EWKB.generate(FACTORY.project(geom))
    where("ST_Intersects(boundary, ST_GeomFromEWKB(E'\\\\x#{ewkb}'))")
  end

end
