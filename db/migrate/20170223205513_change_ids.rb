class ChangeIds < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :rid, :string, null: false, index: true
    add_column :users, :rid, :string
    add_index :users, :rid, unique: true
  end
end
