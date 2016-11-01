Rails.application.routes.draw do

    get 'palm_two/index'

    resources :forecast_96s
    resources :forecast_72s
    resources :forecast_48s
    resources :forecast_24s
    resources :station_hours
    resources :station_dailies
    resources :city_hours
    resources :city_dailies
    get 'coal_map' => 'map#coal'

    #Casein routes
    namespace :casein do
        resources :forecast_daily_data
    end

    #get 'counties/lookup'
    get 'counties/to_geojson'

    get 'querys/aqis_by_city' => 'querys#aqis_by_city'
    get 'querys/aqis_by_city/city' => 'querys#aqis_by_cityid'
    get 'querys/aqis_by_city/:city' => 'querys#aqis_by_city'
    # get 'querys/aqis_by_city/city/id/:cityid' => 'querys#aqis_by_cityid'
    get 'querys' => 'querys#cities'
    get 'querys/all_cities' => 'querys#all_cities2'
    get 'querys/adj' => 'querys#adj'
    get 'querys/adj_5days' => 'querys#adj_5days'
    get 'querys/monitor_data' => 'querys#monitor_data'
    get 'querys/get_weather_air_data' => 'querys#get_weather_air_data'

    get 'mmap' => 'welcome#monitor_map'

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
    #root 'predict#index'
    get '/compare' => 'welcome#compare'
    get '/bdqx_compare' => 'welcome#bdqx_compare'  
    get '/sfcities_compare' => 'welcome#sfcities_compare' 
    get '/real_time_monitoring' => 'welcome#real_time_monitoring'
    get '/history_data' => 'welcome#history_data'
    get '/forecast' => 'welcome#forecast'
    get '/real_map' => 'welcome#real_map'
    get '/case' => 'welcome#case'
    get '/about' => 'welcome#about'
    get '/rank1503' => 'welcome#rank1503'
    get '/map' => 'welcome#map'
    get '/bar' => 'welcome#bar', as: :bar_welcome
    get '/subindex' => 'welcome#subindex', as: :subindex_welcome
    get '/pinggu' => 'welcome#pinggu', as: :pinggu_welcome
    get '/visits_by_day' => 'welcome#visits_by_day', as: :visits_by_day_welcome
    get 'welcome/adj_ajax/:type/:post' => 'welcome#adj_ajax', as: :adj_ajax_welcome
    get 'welcome/chartway' => 'welcome#chartway'
    get 'welcome/city_compare_chart' => 'welcome#city_compare_chart'
    get 'welcome/bdqx_compare_chart' => 'welcome#bdqx_compare_chart'
    get 'welcome/get_history_data/:model/:time' => 'welcome#get_history_data'
    get 'welcome/get_forecast_baoding' => 'welcome#get_forecast_baoding' 
    get 'welcome/get_city_point' => 'welcome#get_city_point'  
    get 'welcome/export_data_xls/:city' => 'welcome#export_data_xls'  
    get '/adj_pie' => 'welcome#adj_pie'
    get '/welcome/cities_around_fun' => 'welcome#cities_around_fun'

    #秦皇岛路由
    get '/qinhuangdao' => 'qinhuangdao#pinggu'
    get '/qinhuangdao/compare' => 'qinhuangdao#compare'
    get '/qinhuangdao/qhdqx_compare' => 'qinhuangdao#qhdqx_compare'  
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
    get 'qinhuangdao/sfcities_compare_chart' => 'qinhuangdao#sfcities_compare_chart'
    get 'qinhuangdao/qhdqx_compare_chart' => 'qinhuangdao#qhdqx_compare_chart'
    get 'qinhuangdao/get_history_data/:model/:time' => 'qinhuangdao#get_history_data'
    get 'qinhuangdao/get_forecast_baoding' => 'qinhuangdao#get_forecast_baoding' 
    get 'qinhuangdao/get_city_point' => 'qinhuangdao#get_city_point'  
    get '/qinhuangdao/adj_pie' => 'qinhuangdao#adj_pie'
    get '/qinhuangdao/cities_around_fun' => 'qinhuangdao#cities_around_fun'
    get '/qinhuangdao/get_linechart_data' => 'qinhuangdao#get_linechart_data'
    get '/qinhuangdao/get_rank_chart_data' => 'qinhuangdao#get_rank_chart_data'
    get '/qinhuangdao/sourceAnalysisPieChart' => 'qinhuangdao#sourceAnalysisPieChart'
    get '/qinhuangdao/ltjc' => 'qinhuangdao#ltjc'


    #秦皇岛空气质量预报预警
    get 'predict/index' => 'predict#index'
    get 'predict/analysis' => 'predict#analysis'
    get 'predict/pollution_situation_analysis' => 'predict#pollution_situation_analysis'
    get 'predict/source_analysis' => 'predict#source_analysis'
    get 'predict/model_forecast_analysis' => 'predict#model_forecast_analysis'
    get 'predict/site_comparative_analysis' => 'predict#site_comparative_analysis'
    get 'predict/revise' => 'predict#revise'



    #廊坊路由
    get 'langfang/index' => 'langfang#forecast'
    get 'langfang/lf_forecast_pics'

    #palm 2.0
    get 'palm_two/scheme_simulation' => 'palm_two#scheme_simulation'
    get 'palm_two/get_all_data' => 'palm_two#get_all_data'
    get 'palm_two/effect_evaluation' => 'palm_two#effect_evaluation'
    get 'palm_two/query_gou_xuan_en_data_all' => 'palm_two#query_gou_xuan_en_data_all'

end
