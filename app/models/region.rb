class Region < ActiveRecord::Base
  FACTORY = RGeo::Geographic.simple_mercator_factory
  #FACTORY = RGeo::Geographic.spherical_factory(:srid => 3785)
  set_rgeo_factory_for_column(:boundary, FACTORY.projection_factory)
  EWKB = RGeo::WKRep::WKBGenerator.new(:type_format => :ewkb,
                                       :emit_ewkb_srid => true, :hex_format => true)

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

  def self.containing_latlon(lat, lon)
    ewkb = EWKB.generate(FACTORY.point(lon, lat).projection)
    where("ST_Intersects(boundary, ST_GeomFromEWKB(E'\\\\x#{ewkb}'))")
  end

end
