class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.string :title, null: false, unique: true
      t.timestamps
    end
  end
end
