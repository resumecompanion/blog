class AddGplusUrlToUsers < ActiveRecord::Migration
  def change
    add_column :blog_users, 'gplus_url', :string
  end
end
