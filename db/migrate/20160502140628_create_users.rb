class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :user_name
      t.string :password
      t.string :mobile_number
      t.string :auth_token
      t.datetime :auth_token_expires_at
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.references :limo_company
      t.references :role

      t.timestamps null: false
    end
  end
end
