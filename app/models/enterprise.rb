class Enterprise < ActiveRecord::Base
	def get_enterprise_data
		result=Enterprise.all
		result
	end
end
