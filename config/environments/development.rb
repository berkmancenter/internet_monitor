Imon::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.eager_load = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # See everything in the log (default is :info)
  config.log_level = :info

  # Don't care if the mailer can't send
  if config.respond_to?(:action_mailer)
    config.action_mailer.raise_delivery_errors = false

    # Print deprecation notices to the Rails logger
    config.active_support.deprecation = :log

    # Do not compress assets
    config.assets.js_compress = nil

    # Expands the lines which load the assets
    config.assets.debug = true

    # Keep Refinery from overriding defaults
    config.after_initialize do |app|
        app.config.assets.debug = true
    end

    config.action_mailer.default_url_options = { :host => 'www.thenetmonitor.org' }
    Rails.application.routes.default_url_options[:host] = 'www.thenetmonitor.org'

    config.action_mailer.delivery_method = :sendmail
    config.action_mailer.perform_deliveries = true
end

if !( Rails.const_defined?( 'Server' ) || Rails.const_defined?( 'Console' ) )
    Imon::Application.config.middleware.use ExceptionNotification::Rack, :email => {
      :email_prefix => "[IM] ",
      :sender_address => %{"Internet Monitor" <info@thenetmonitor.org>},
      :exception_recipients => %w{rwestphal@cyber.law.harvard.edu}
    }
  end
end
