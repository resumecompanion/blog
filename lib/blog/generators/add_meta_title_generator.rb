require 'rails/generators'

module Blog
  module Generators
    class AddMetaTitleGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Copy add_meta_title_to_post.rb file"

      def copy_migration
        copy_file "migrations/add_meta_title_to_post.rb", "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%2N")}_add_meta_title_to_post.rb"
      end
    end
  end
end