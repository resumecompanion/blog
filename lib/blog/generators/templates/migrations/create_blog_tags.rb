class CreateBlogTags < ActiveRecord::Migration
  def change
    create_table :blog_tags do |t|
      t.string :name
      t.string :slug
      t.string :meta_description
      t.string :meta_keywords
      t.timestamps
    end
  end
end
