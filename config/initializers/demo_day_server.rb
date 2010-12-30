Rails.configuration.demo_day_server = ENV['DEMO_DAY_SERVER']
Rails.configuration.demo_day_server ||= YAML.load_file(File.join(Rails.root, "config", "demo_day_server.yml"))[:server_url]