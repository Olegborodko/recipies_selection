class DeleteRoles < ActiveRecord::Migration[5.1]
  def change
    drop_table :roles
  end
end
