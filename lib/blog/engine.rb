require 'rack-rewrite'
require 'thinking_sphinx'

module Blog
  class Engine < ::Rails::Engine
    isolate_namespace Blog

    initializer :monkey_patch_kaminiari do
      module ::Kaminari
        module Helpers
          class Tag
            alias_method :old_page_url_for, :page_url_for
            def page_url_for(page)
              old_page_url_for(page).gsub(/\/$/, '')
            end
          end
        end
      end
    end

    initializer :append_migrations do |app|
      unless app.root.to_s == root.to_s
        app.config.paths["db/migrate"] += config.paths["db/migrate"].expanded
      end
    end   

    config.app_middleware.insert_before(Rack::Lock, Rack::Rewrite) do
      r301 %r{^/(.*)/$}, '/$1'
    end

    initializer "cms.precompile_assets" do |app|
      app.config.assets.precompile += %w( blog/application.js, blog/resumegenius.css blog/resumecompanion.css blog/admin.js blog/admin.css )
      app.config.assets.precompile += %w( blog/plugin/ckeditor/init.js blog/plugin/ckeditor/*)
    end
    
  end
end
