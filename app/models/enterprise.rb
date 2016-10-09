class Enterprise < ActiveRecord::Base
	def get_enterprise_data(gridPoint="")
		result=[]
		if gridPoint==''
			result=Enterprise.all
		else

			gridPoint.each do |grid|
				xmin=grid['xmin'].to_f#longitude
				xmax=grid['xmax'].to_f
				ymin=grid['ymin'].to_f#latitude
				ymax=grid['ymax'].to_f
				tmp=Enterprise.where(longitude: xmin..xmax).where(latitude: ymin..ymax)
				result+=tmp
			end
		end
		result
	end
end
