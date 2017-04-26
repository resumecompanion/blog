$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "blog/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "blog"
  s.version     = Blog::VERSION
  s.authors     = ["Josh"]
  s.email       = ["josh@resumecompanion.com"]
  s.homepage    = "https://resumegenius.com/"
  s.summary     = "Blog"
  s.description = "blog"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.0"
  s.add_dependency "devise"
  s.add_dependency "simple_form"
  s.add_dependency "compass-rails"
  s.add_dependency "carrierwave"
  s.add_dependency "kaminari"
  s.add_dependency "stringex"
  s.add_dependency "thinking-sphinx", '~> 2.0.13'
  s.add_dependency "rack-rewrite"
  s.add_dependency "mini_magick"
end
