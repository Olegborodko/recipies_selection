class AddDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :ingredients, :calories, :integer
    add_column :ingredients, :protein, :float
    add_column :ingredients, :fat, :float
    add_column :ingredients, :carbohydrate, :float
  end
end
