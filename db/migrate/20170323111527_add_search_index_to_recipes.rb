class AddSearchIndexToRecipes < ActiveRecord::Migration[5.0]
  def up
    execute "create index recipes_name on recipes using gin(to_tsvector('english', name))"
    execute "create index recipes_content on recipes using gin(to_tsvector('english', content))"
  end

  def down
    execute "drop index recipes_name"
    execute "drop index recipes_content"
  end
end
