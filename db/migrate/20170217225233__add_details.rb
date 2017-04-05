class AddDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :ingredients, :calories, :integer
    add_column :ingredients, :protein, :integer
    add_column :ingredients, :fat, :integer
    add_column :ingredients, :carbohydrate, :integer
  end
end
