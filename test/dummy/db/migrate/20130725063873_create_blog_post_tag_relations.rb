class CreateBlogPostTagRelations < ActiveRecord::Migration
  def change
    create_table :blog_post_tag_relations do |t|
      t.integer :post_id
      t.integer :tag_id
      t.timestamps
    end

    add_index :blog_post_tag_relations, :post_id
    add_index :blog_post_tag_relations, :tag_id
  end
end
