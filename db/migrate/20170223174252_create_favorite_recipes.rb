class CreateFavoriteRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :favorite_recipes do |t|
      t.belongs_to :user, index: true
      t.belongs_to :recipe, index: true
      t.text :note
      t.timestamps
    end
  end
end
