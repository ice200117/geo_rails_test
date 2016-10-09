class Enterprise < ActiveRecord::Base
	def get_enterprise_data(gridPoint,init)
		result=[]
		if init.to_i==1
			result=Enterprise.all
		else
			gridPoint=gridPoint[1..-2]
			gridPoints=gridPoint.split(",")
			gridPoints.each do |grid|
				grids=Hash[*grid.split(",")]
				xmin=grids['xmin'].to_f#longitude
				xmax=grids['xmax'].to_f
				ymin=grids['ymin'].to_f#latitude
				ymax=grids['ymax'].to_f
				tmp=Enterprise.where(longitude: xmin..xmax).where(latitude: ymin..ymax)
				result+=tmp
			end
		end
		result
	end
end
