# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( 
	map_welcome.js 
	css/styles.css 
	css/button.css 
	jquery.cookie.js 
	jquery.min.js 
	bootstrap.min.js 
	citySelector.js 
	jquery-ui-datepicker.js 
	css/wdatepicker.css 
	css/jquery-ui.css 
	map.js 
	map.css 
	css/daterangepicker-bs3.css 
	chart.js 
	bootstrap-table.min.js 
	moment.js 
	daterangepicker.js 
	crypto_zq-min.js 
	city_compare_chart.js 
	css/bootstrap.min.css 
	css/bootstrap-table.min.css 
	respond.js 
	bdqxSelector.js 
	bdqx_compare_chart.js 
	barcity.js 
	rank_chart.js 
	LineChart.js 
	qinhuangdao.css
	css/air.css
	air.js
	demo.js
	langfang.css
	data-turbolinks-track.js
)
