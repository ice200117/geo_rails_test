require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'rgeo'
require 'iconv'
require 'active_record/connection_adapters/postgis_adapter/railtie'
require 'will_paginate'
require 'numru/netcdf'
#require 'will_paginate/active_record'  # or data_mapper/sequel

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


module GeoRailsTest
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    #

    config.autoload_paths += %W(#{config.root}/lib )

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Beijing'
	#config.active_record.default_timezone = :local
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    #config.active_record.raise_in_transactional_callbacks = true

    #config.assets.precompile += ['bootstrap-sass/dropdown.js']
    
    # Page cache
    config.action_controller.page_cache_directory = "#{Rails.root.to_s}/public/deploy"

	config.active_record.observers = :china_cities_hour_observer

  end
end
