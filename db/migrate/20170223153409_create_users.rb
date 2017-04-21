class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false
      t.string :name, null: false
      t.belongs_to :role, index: true, null: false
      t.text :description
      t.string  "rid", null: false, unique: true, index: true
      t.timestamps
    end
  end
end
