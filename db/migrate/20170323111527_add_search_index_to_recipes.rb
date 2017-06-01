class AddSearchIndexToRecipes < ActiveRecord::Migration[5.1]
  def up
    execute "create index recipes_name on recipes using gin(to_tsvector('russian', name))"
    execute "create index recipes_content on recipes using gin(to_tsvector('russian', content))"
  end

  def down
    execute 'drop index recipes_name'
    execute 'drop index recipes_content'
  end
end
