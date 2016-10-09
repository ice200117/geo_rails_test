class Enterprise < ActiveRecord::Base
	def get_enterprise_data(gridPoint,init)
		result=[]
		if init.to_i==1
			result=Enterprise.all
		else
			gridPoint=gridPoint[1..-2]
			gridPoints=gridPoint.split(",")
			gridPoints.each do |grid|
				xmin=grid.xmin#longitude
				xmax=grid.xmax
				ymin=grid.ymin#latitude
				ymax=grid.ymax
				tmp=Enterprise.where(longitude: xmin..xmax).where(latitude: ymin..ymax)
				result+=tmp
			end
		end
		result
	end
end
