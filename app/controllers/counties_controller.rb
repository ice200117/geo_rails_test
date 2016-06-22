class CountiesController < ApplicationController
  def lookup
    #lat = params[:lat].to_f
    #lon = params[:lon].to_f
    lat = 38
    lon = 116
    c = County.containing_latlon(lat, lon).first
    render(:json => {:lat => lat, :lon => lon,
      :county => c ? c.name : nil, :centroid_y => c.centroid_y, :centroid_x => c.centroid_x})

  end

  def to_geojson
    respond_to do |format|
      format.json {
        render json: County.to_geojson
      }
    end
  end
end
