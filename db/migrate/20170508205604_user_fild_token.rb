class UserFildToken < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :encrypted_token, :string
    add_column :users, :encrypted_token_iv, :string
  end
end
