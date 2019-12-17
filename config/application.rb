require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AppName
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.i18n.default_locale = :ja
    config.time_zone = 'Tokyo'
    
    config.generators do |g|
      g.test_framework(
        :rspec,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        request_specs: false
      )
    end

    # coffee script排除に際して記述
    config.generators.javascript_engine = :js
  end
end
