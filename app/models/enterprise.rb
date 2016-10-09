class Enterprise < ActiveRecord::Base
	def get_enterprise_data(gridPoint,init)
		result=[]
		if init.to_i==1
			result=Enterprise.all
		else
			gridPoint=gridPoint[1..-2]
			gridPoints=gridPoint.split(",")
			gridPoints.each do |grid|
				grid=grid[1..-2]
				grids=grid.split(",")
				xmin=grids[0].to_f#longitude
				xmax=grids[2].to_f
				ymin=grids[1].to_f#latitude
				ymax=grids[3].to_f
				tmp=Enterprise.where(longitude: xmin..xmax).where(latitude: ymin..ymax)
				result+=tmp
			end
		end
		result
	end
end
