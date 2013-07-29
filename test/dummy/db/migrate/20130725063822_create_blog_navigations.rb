class CreateBlogNavigations < ActiveRecord::Migration
  def change
    create_table :blog_navigations do |t|
      t.string :name
      t.string :link
      t.string :link_title
      t.integer :position, :default => 0
      t.boolean :is_hidden, :default => false
      t.timestamps
    end

    add_index :blog_navigations, :position
    add_index :blog_navigations, :is_hidden
  end
end

