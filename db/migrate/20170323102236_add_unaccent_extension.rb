class AddUnaccentExtension < ActiveRecord::Migration[5.0]
  def up
    execute "create extension unaccent"
  end

  def down
    execute "drop extension unaccent"
  end
end
