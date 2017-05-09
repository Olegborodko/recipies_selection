class UserStatus < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :role_id, :status
    change_column :users, :status, :integer, :default => 0, null: false, index: true
  end
end
