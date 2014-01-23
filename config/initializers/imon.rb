Imon::Application.config.imon = YAML.load_file(Rails.root.join('config', 'imon.yml'))[Rails.env]

# spits out 'already initialized constant' warning (silenced!) but required for twitter gem
silence_warnings do
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE unless Rails.env.production?
end
