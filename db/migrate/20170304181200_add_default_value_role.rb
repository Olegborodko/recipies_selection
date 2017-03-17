class AddDefaultValueRole < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :role_id, :integer, :default => 1, null: false, index: true
  end
end
