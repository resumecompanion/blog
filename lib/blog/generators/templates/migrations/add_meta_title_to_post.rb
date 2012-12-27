class AddMetaTitleToPost < ActiveRecord::Migration
  def change
    add_column :blog_posts, :meta_title, :string
  end
end
