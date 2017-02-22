class CreateRecipeCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :recipe_categories do |t|
      t.string :title
    end
  end
end
