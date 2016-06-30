class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :first_name
      t.string :last_name
      t.string :password
      t.string :email
      t.string :mobile_number
      t.string :auth_token
      t.datetime :auth_token_expires_at
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      t.timestamps null: false
    end
    add_index :admins, :email, unique: true
    add_index :admins, :auth_token, unique: true
    add_index :admins, :reset_password_token, unique: true
  end
end
