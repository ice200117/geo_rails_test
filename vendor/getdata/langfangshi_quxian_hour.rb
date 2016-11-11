require_relative 'common.rb'
#廊坊实时数据
hs=ten_times_test(TempLfHour,'shishi_74',{secret:'LANGFANGRANK',type:'HOUR'})
save_db(hs,TempLfHour)
TempLfHour.new.atmospheric_volume_superscalar
