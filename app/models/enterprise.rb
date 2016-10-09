class Enterprise < ActiveRecord::Base
	def get_enterprise_data(gridPoint,init)
		result=[]
		if init.to_i==1
			result=Enterprise.all
		else
			gridPoints=gridPoint.split(",")
			# gridPoints.each do |grid|
				xmin=gridPoints[0].to_f#longitude
				xmax=gridPoints[2].to_f
				ymin=gridPoints[1].to_f#latitude
				ymax=gridPoints[3].to_f
				tmp=Enterprise.where(longitude: xmin..xmax).where(latitude: ymin..ymax)
				result+=tmp
			# end
		end
		result
	end
end
