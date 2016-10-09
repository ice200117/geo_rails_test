class Enterprise < ActiveRecord::Base
	def get_enterprise_data(gridPoint)
		result=[]
		if gridPoint=='init'
		result=Enterprise.all
		else
			gridPoint.each do |grid|
				xmin=grid['xmin']#longitude
				xmax=grid['xmax']
				ymin=grid['ymin']#latitude
				ymax=grid['ymax']
				tmp=Enterprise.where(longitude: xmin..xmax).where(latitude: ymin..ymax)
				result+=tmp
			end
		end
		result
	end
end
