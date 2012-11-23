class CreateBlogTags < ActiveRecord::Migration
  def change
    create_table :blog_tags do |t|
      t.string :name
      t.string :slug
      t.boolean :is_enabled, :default => true
      t.string :meta_description
      t.string :meta_keywords
      t.integer :old_id
      t.timestamps
    end
  end
end
