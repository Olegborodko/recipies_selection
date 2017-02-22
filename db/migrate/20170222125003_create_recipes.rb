class CreateRecipes < ActiveRecord::Migration[5.0]
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :content
      t.integer :recipes_category_id
      t.string :cooking_time
      t.string :ingredients
      t.string :number_of_ingredients
      t.integer :ccal

      t.timestamps
    end
    add_index :recipes, [:recipes_category_id]
  end
end
