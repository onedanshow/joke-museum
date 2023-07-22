require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JokeMuseum
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end

ShopifyAPI::Context.setup(
  api_key: ENV['SHOPIFY_API_KEY'],
  api_secret_key: ENV['SHOPIFY_API_SECRET_KEY'],
  host: "<https://application-host-name.com>",
  scope: "read_analytics, read_content, read_customers, read_fulfillments, read_orders, read_products, read_script_tags, read_shipping, write_themes, read_inventory, read_locations, read_themes, write_content",
  is_embedded: false, # Set to true if you are building an embedded app
  api_version: "2023-07", # The version of the API you would like to use
  is_private: false, # Set to true if you have an existing private app
)