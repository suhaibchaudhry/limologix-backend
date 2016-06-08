class CreateDrivers < ActiveRecord::Migration
  def change
    create_table :drivers do |t|
      t.string :first_name
      t.string :last_name
      t.string :password
      t.string :email
      t.string :mobile_number
      t.date :dob
      t.string :home_phone_number
      t.string :social_security_number
      t.string :display_name
      t.string :auth_token
      t.datetime :auth_token_expires_at
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.boolean :available, default: true
      t.string :company
      t.string :license_number
      t.string :license_image
      t.date :license_expiry_date
      t.string :badge_number
      t.date :badge_expiry_date
      t.string :ara_number
      t.string :ara_image
      t.date :ara_expiry_date
      t.string :insurance_company
      t.string :insurance_policy_number
      t.date :insurance_expiry_date
    end

    add_index :drivers, :email, unique: true
    add_index :drivers, :reset_password_token, unique: true
    add_index :drivers, :auth_token, unique: true
  end
end