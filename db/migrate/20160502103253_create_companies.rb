class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :uid
      t.string :name
      t.string :logo
      t.string :email
      t.string :primary_phone_number
      t.string :secondary_phone_number

      t.timestamps null: false
    end
    add_index :companies, :email, unique: true
    add_index :companies, :uid, unique: true
  end
end