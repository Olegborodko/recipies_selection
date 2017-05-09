class CreateIngredientCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredient_categories do |t|
      t.string :title, unique: true

      t.timestamps
    end
  end
end
