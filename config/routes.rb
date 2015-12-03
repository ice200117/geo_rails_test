Rails.application.routes.draw do
  #get 'counties/lookup'
  get 'querys/aqis_by_city' => 'querys#aqis_by_city'
  get 'querys' => 'querys#cities'
  get 'querys/all_cities' => 'querys#all_cities2'
  get 'querys/adj' => 'querys#adj'
  get 'querys/adj_5days' => 'querys#adj_5days'
  get 'querys/monitor_data' => 'querys#monitor_data'

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
   root 'welcome#pinggu'
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
   #get '/show' => 'welcome#show'
   get '/map' => 'welcome#map'
   get '/bar' => 'welcome#bar', as: :bar_welcome
   get '/pinggu' => 'welcome#pinggu', as: :pinggu_welcome
   get '/visits_by_day' => 'welcome#visits_by_day', as: :visits_by_day_welcome

   get 'welcome/adj_ajax/:type/:post' => 'welcome#adj_ajax', as: :adj_ajax_welcome

   get 'welcome/chartway' => 'welcome#chartway'
   get 'welcome/city_compare_chart' => 'welcome#city_compare_chart'
   get 'welcome/bdqx_compare_chart' => 'welcome#bdqx_compare_chart'
   get 'welcome/get_history_data/:model/:time' => 'welcome#get_history_data'
   get 'welcome/get_forecast_baoding' => 'welcome#get_forecast_baoding' 
   get 'welcome/get_city_point' => 'welcome#get_city_point'  


   get '/adj_pie' => 'welcome#adj_pie'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
