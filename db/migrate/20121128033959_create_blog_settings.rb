class CreateBlogSettings < ActiveRecord::Migration
  def change
    create_table :blog_settings do |t|
      t.string :key
      t.string :value
      t.string :description
      t.timestamps
    end

    add_index :blog_settings, :key, :unique => true
  end
end
