Imon::Application.config.middleware.use ExceptionNotification::Rack,
  :email => {
    :email_prefix => "[IM] ",
    :sender_address => %{"Internet Monitor" <info@thenetmonitor.org>},
    :exception_recipients => %w{rwestphal@cyber.law.harvard.edu}
  }

