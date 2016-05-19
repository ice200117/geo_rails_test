Rails.application.routes.draw do
	#get 'counties/lookup'
	get 'querys/aqis_by_city' => 'querys#aqis_by_city'
	get 'querys/aqis_by_city/:city' => 'querys#aqis_by_city'
	# get 'querys/aqis_by_city/city' => 'querys#aqis_by_cityid'
	# get 'querys/aqis_by_city/city/id/:cityid' => 'querys#aqis_by_cityid'
	get 'querys' => 'querys#cities'
	get 'querys/all_cities' => 'querys#all_cities2'
	get 'querys/adj' => 'querys#adj'
	get 'querys/adj_5days' => 'querys#adj_5days'
	get 'querys/monitor_data' => 'querys#monitor_data'
	get 'querys/get_weather_air_data' => 'querys#get_weather_air_data'


	#get '/forecast_points/lookup' => 'forecast_points#lookup'
	#resources :forecast_points

	resources :forecast_points do
		get 'lookup', :on => :collection
	end

	mount ChinaCity::Engine => '/china_city'

	# The priority is based upon order of creation: first created -> highest priority.
	# See how all your routes lay out with "rake routes".
	# You can have the root of your site routed with "root"
	#root 'welcome#index'
	#root 'welcome#map'
	root 'qinhuangdao#pinggu'
#	get '/compare' => 'welcome#compare'
	#get '/bdqx_compare' => 'welcome#bdqx_compare'  
	#get '/sfcities_compare' => 'welcome#sfcities_compare' 
	#get '/real_time_monitoring' => 'welcome#real_time_monitoring'
	#get '/history_data' => 'welcome#history_data'
	#get '/forecast' => 'welcome#forecast'
	#get '/real_map' => 'welcome#real_map'
	#get '/case' => 'welcome#case'
	#get '/about' => 'welcome#about'
	#get '/rank1503' => 'welcome#rank1503'
	#get '/map' => 'welcome#map'
	get '/bar' => 'welcome#bar', as: :bar_welcome
	#get '/subindex' => 'welcome#subindex', as: :subindex_welcome
	#get '/pinggu' => 'welcome#pinggu', as: :pinggu_welcome
	#get '/visits_by_day' => 'welcome#visits_by_day', as: :visits_by_day_welcome
	get 'welcome/adj_ajax/:type/:post' => 'welcome#adj_ajax', as: :adj_ajax_welcome
	get 'welcome/chartway' => 'welcome#chartway'
	get 'welcome/city_compare_chart' => 'welcome#city_compare_chart'
	get 'welcome/bdqx_compare_chart' => 'welcome#bdqx_compare_chart'
	get 'welcome/get_history_data/:model/:time' => 'welcome#get_history_data'
	get 'welcome/get_forecast_baoding' => 'welcome#get_forecast_baoding' 
	get 'welcome/get_city_point' => 'welcome#get_city_point'  
	get 'welcome/export_lfdata_xls' => 'welcome#export_lfdata_xls'  
	#get '/adj_pie' => 'welcome#adj_pie'
	get '/welcome/cities_around_fun' => 'welcome#cities_around_fun'

	#秦皇岛路由
	get '/qinhuangdao' => 'qinhuangdao#pinggu'
	get '/qinhuangdao/compare' => 'qinhuangdao#compare'
	get '/qinhuangdao/bdqx_compare' => 'qinhuangdao#bdqx_compare'  
	get '/qinhuangdao/sfcities_compare' => 'qinhuangdao#sfcities_compare' 
	get '/qinhuangdao/real_time_monitoring' => 'qinhuangdao#real_time_monitoring'
	get '/qinhuangdao/history_data' => 'qinhuangdao#history_data'
	get '/qinhuangdao/forecast' => 'qinhuangdao#forecast'
	get '/qinhuangdao/real_map' => 'qinhuangdao#real_map'
	get '/qinhuangdao/case' => 'qinhuangdao#case'
	get '/qinhuangdao/about' => 'qinhuangdao#about'
	get '/qinhuangdao/rank1503' => 'qinhuangdao#rank1503'
	get '/qinhuangdao/map' => 'qinhuangdao#map'
	get '/qinhuangdao/bar' => 'qinhuangdao#bar', as: :bar_qinhuangdao
	get '/qinhuangdao/subindex' => 'qinhuangdao#subindex', as: :subindex_qinhuangdao
	get '/qinhuangdao/pinggu' => 'qinhuangdao#pinggu', as: :pinggu_qinhuangdao
	get 'qinhuangdao/visits_by_day' => 'qinhuangdao#visits_by_day', as: :visits_by_day_qinhuangdao
	get 'qinhuangdao/adj_ajax/:type/:post' => 'qinhuangdao#adj_ajax', as: :adj_ajax_qinhuangdao
	get 'qinhuangdao/chartway' => 'qinhuangdao#chartway'
	get 'qinhuangdao/city_compare_chart' => 'qinhuangdao#city_compare_chart'
	get 'qinhuangdao/bdqx_compare_chart' => 'qinhuangdao#bdqx_compare_chart'
	get 'qinhuangdao/get_history_data/:model/:time' => 'qinhuangdao#get_history_data'
	get 'qinhuangdao/get_forecast_baoding' => 'qinhuangdao#get_forecast_baoding' 
	get 'qinhuangdao/get_city_point' => 'qinhuangdao#get_city_point'  
	get '/qinhuangdao/adj_pie' => 'qinhuangdao#adj_pie'
	get '/qinhuangdao/cities_around_fun' => 'qinhuangdao#cities_around_fun'
	get '/qinhuangdao/get_linechart_data' => 'qinhuangdao#get_linechart_data'
	get '/qinhuangdao/get_rank_chart_data' => 'qinhuangdao#get_rank_chart_data'

end
