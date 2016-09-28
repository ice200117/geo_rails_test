# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += %w( 
  vendor/jquery.timeliner.min.js
  vendor/leaflet.ChineseTmsProviders.js
  vendor/OSMBuildings-Leaflet.js
  css/timeliner.css
  css/timeliner_styling.css
  jquery-ui-datepicker.js
  css/jquery-ui.css
	adj_map.js 
	css/styles.css 
	css/button.css 
	css/wdatepicker.css
	jquery.cookie.js 
	jquery.min.js 
	bootstrap.min.js 
	citySelector.js 
	map.js 
	map.css 
	css/daterangepicker-bs3.css 
	chart.js 
	bootstrap-table.min.js 
	moment.js 
	daterangepicker.js 
	crypto_zq-min.js 
	sfcities_compare_chart.js 
	css/bootstrap.min.css 
	css/bootstrap-table.min.css 
	respond.js 
	qhdqxSelector.js 
	qhdqx_compare_chart.js 
	barcity.js 
	rank_chart.js 
	LineChart.js 
	qinhuangdao.css
	css/air.css
	air.js
	demo.js
	langfang.css
	data-turbolinks-track.js
	cities_around.js
	SfcitiesSelector.js
	css/login.css
	css/font-awesome.css
	css/loginstyle.css
	modernizr.custom.js
	echarts.min.js
	infographic.js
	sandian.js
	highcharts.js
    leaflet.js
    leaflet.css
 
    css/bootstrap/dist/css/bootstrap.min.css
    css/font-awesome/css/font-awesome.min.css
    css/custom.min.css
    js/jquery/dist/jquery.min.js
    js/bootstrap/dist/js/bootstrap.min.js
    js/fastclick/lib/fastclick.js
    js/echarts/dist/echarts.min.js
    js/custom.min.js
    source_analysis_custom.js
    js/icheck/skins/flat/green.css
    css/jqvmap/dist/jqvmap.min.css
    pollution_situation_analysis_air.js
    buttons.css
    img/ico.png
)
