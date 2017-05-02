class CreateIngredients < ActiveRecord::Migration[5.0]
  def change
    create_table :ingredients do |t|
      t.string :name, unique: true
      t.text :content
      t.string :href
      t.integer :ingredient_category_id

      t.timestamps
    end
    add_index :ingredients, [:ingredient_category_id]
  end
end
