class CreateBlogPostTagRelations < ActiveRecord::Migration
  def change
    create_table :blog_post_tag_relations do |t|
      t.integer :post_id
      t.integer :tag_id
      t.timestamps
    end
  end
end
