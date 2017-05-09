class AddIndexToUserEmailAndRolesTitle < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :email, unique: true
    change_column :users, :rid, :string, unique: true
    add_index :roles, :title, unique: true
  end
end
