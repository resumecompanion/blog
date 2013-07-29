module Blog
  class Engine < ::Rails::Engine
    isolate_namespace Blog
    
    config.app_middleware.insert_before(Rack::Lock, Rack::Rewrite) do
      r301 %r{^/(.*)/$}, '/$1'
    end
  end
end
