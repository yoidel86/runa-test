require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
# require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Runa
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.autoload_paths << Rails.root.join('lib')

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.


    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    # enable assets to client
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.assets.paths += %W(#{config.root}/app/assets/images/** #{config.root}/app/assets/javascripts/** #{config.root}/app/assets/stylesheets/** #{config.root}/app/assets/fonts/**)
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif *.eot *.svg *.ttf *.otf *.woff)
    config.action_dispatch.default_headers = {
        'Access-Control-Allow-Origin' =>  '*',
        'Access-Control-Request-Method' => %w{GET POST OPTIONS}.join(",")
    }
    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
  end
end