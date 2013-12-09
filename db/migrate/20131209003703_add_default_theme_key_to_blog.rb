class AddDefaultThemeKeyToBlog < ActiveRecord::Migration
  def up
    Blog::Setting.create key: 'global:theme', value: 'resumecompanion', description: 'name of theme``'
  end

  def down
    Blog::Setting.find_by_name('global:theme').destroy
  end
end
