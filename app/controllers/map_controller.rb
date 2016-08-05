class MapController < ApplicationController
  def coal
    @cf = County.all.map {|c| c.to_geojson }

		respond_to do |format|
      format.html {
        render layout: false
      }
			format.js   {}
			format.json {}
		end
  end
end
