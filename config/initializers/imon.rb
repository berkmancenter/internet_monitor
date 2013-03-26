Imon::Application.config.imon = YAML.load_file(Rails.root.join('config', 'imon.yml'))[Rails.env]
