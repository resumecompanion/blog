require 'rails/generators'

module Blog
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Copy Blog default files"

      def copy_initialize
        #copy_file "initializers/blog.rb", "config/initializers/blog.rb"
      end

      def copy_migration
        copy_file "migrations/devise_create_blog_users.rb", "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%2N")}_devise_create_blog_users.rb"
        sleep 0.1
      end

      # def show_readme
      #     readme "README"
      # end

    end
  end
end