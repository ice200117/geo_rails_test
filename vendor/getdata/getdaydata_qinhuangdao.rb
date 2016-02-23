require_relative './common.rb'

def day_data_common(hs,model)
	if hs != false 
		if model.last.nil? || hs[:time].to_time > model.last.data_real_time
			return true
		else
			return false
		end
	else
		return false
	end
end

hs=Hash.new
time=Time.now.yesterday
