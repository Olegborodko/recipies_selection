class RenameRecipeCategoryId < ActiveRecord::Migration[5.1]
  def change
    rename_column :recipes, :recipes_category_id, :recipe_category_id
  end
end
