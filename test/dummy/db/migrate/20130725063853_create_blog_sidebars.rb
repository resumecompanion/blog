class CreateBlogSidebars < ActiveRecord::Migration
  def change
    create_table :blog_sidebars do |t|
      t.string :name
      t.text :content
      t.timestamps
    end
  end
end
