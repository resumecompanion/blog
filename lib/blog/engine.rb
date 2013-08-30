module Blog
  class Engine < ::Rails::Engine
    isolate_namespace Blog
    
    config.app_middleware.insert_before(Rack::Lock, Rack::Rewrite) do
      r301 %r{^/(.*)/$}, '/$1'
    end

    initializer "cms.precompile_assets" do |app|
      app.config.assets.precompile += %w( blog/application.js, blog/application.css blog/admin.js blog/admin.css )
      app.config.assets.precompile += %w( blog/plugin/ckeditor/init.js blog/plugin/ckeditor/*)
    end
    
  end
end
