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
      t.boolean :is_published, :default => true
      t.datetime :published_at
      t.integer :old_id
      t.timestamps
    end

    add_index :blog_posts, :author_id
    add_index :blog_posts, :sidebar_id
    add_index :blog_posts, :slug
    add_index :blog_posts, :is_published
  end
end
