class CreateDrivers < ActiveRecord::Migration
  def change
    create_table :drivers do |t|
      t.string :first_name
      t.string :last_name
      t.string :password
      t.string :email
      t.string :company
      t.string :mobile_number
      t.string :auth_token
      t.datetime :auth_token_expires_at
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.boolean :visible, default: false
      t.string :license_number
      t.string :license_image
      t.date :license_expiry_date
      t.string :badge_number
      t.date :badge_expiry_date
      t.string :ara_image
      t.date :ara_expiry_date
      t.string :insurance_company
      t.string :insurance_policy_number
      t.date :insurance_expiry_date
      t.string :merchant_id
      t.string :customer_profile_id
      t.string :customer_payment_profile_id
      t.integer :toll_credit, default: 0
      t.string :status, default: 'pending'

      t.timestamps null: false
    end

    add_index :drivers, :email, unique: true
    add_index :drivers, :reset_password_token, unique: true
    add_index :drivers, :auth_token, unique: true
    add_index :drivers, :merchant_id, unique: true

  end
end