class CreateBlogFiles < ActiveRecord::Migration
  def change
    create_table :blog_files do |t|
      t.integer :blog_user_id
      t.string :image
      t.string :title
      t.timestamps
    end
  end
end
