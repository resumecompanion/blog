class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.integer :author_id
      t.integer :sidebar_id
      t.string :title
      t.string :slug
      t.string :meta_description
      t.string :meta_keywords
      t.text :content
      t.text :excerpt
      t.boolean :is_published
      t.datetime :published_at
      t.integer :old_id
      t.timestamps
    end
  end
end
