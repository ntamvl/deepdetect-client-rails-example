require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FilterApi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # ActiveModelSerializers.config.adapter = :json_api

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

    config.middleware.use Rack::Attack

    # begin load DeepDetect config
    config_file_path = "#{Rails.root}/config/deepdetect.json"
    model_hash = JSON.parse(File.read(config_file_path))
    model_path = model_hash["model_path"]
    DeepdetectRuby.configure do |config|
      config.host = "http://xdev-web:8080"
      config.model_path = "#{model_path}"
      config.debug = true
      config.is_scaling = false # is_scaling is false ML uses host AND true ML uses servers
      config.servers = "http://127.0.0.1:8080, http://ml1.ntam.me:8080"
    end
    # end load DeepDetect config

  end
end
