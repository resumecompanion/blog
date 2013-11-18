class AddNoIndexToBlogPages < ActiveRecord::Migration
  def change
    add_column :blog_posts, :no_index, :boolean, default: false
  end
end
