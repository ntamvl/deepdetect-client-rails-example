class AddIndexApiKeyToUsers < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :api_key, unique: true
  end
end
