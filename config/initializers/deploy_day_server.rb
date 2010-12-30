Rails.configuration.deploy_day_server = ENV['DEPLOY_DAY_SERVER']
Rails.configuration.deploy_day_server ||= YAML.load_file(File.join(Rails.root, "config", "deploy_day_server.yml"))[:server_url]