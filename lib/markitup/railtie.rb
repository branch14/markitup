module Markitup
  
  case Rails.version.to_i
  when 2
    Rails.configuration.middleware.use Markitup::Middleware,
      :config => File.expand_path('config/markitup.yml', RAILS_ROOT)

  when 3
    class Railtie < Rails::Railtie
      initializer "markitup.insert_middleware" do |app|
        app.config.middleware.use "Markitup::Middleware",
        :config => File.expand_path('config/markitup.yml', Rails.root)
      end

      rake_tasks do
        load File.expand_path('../../../tasks/markitup.rake', __FILE__)
      end
    end

  else
    raise "Unknown Rails version"
  end

end

