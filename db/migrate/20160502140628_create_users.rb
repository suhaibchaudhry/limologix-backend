class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :password
      t.string :email
      t.string :mobile_number
      t.string :auth_token
      t.datetime :auth_token_expires_at
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.references :company, index: true
      t.references :role, index: true
      t.references :admin, index: true

      t.timestamps null: false
    end
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :auth_token, unique: true
  end
end
