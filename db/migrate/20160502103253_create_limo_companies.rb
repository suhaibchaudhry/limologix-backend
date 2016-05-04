class CreateLimoCompanies < ActiveRecord::Migration
  def change
    create_table :limo_companies do |t|
      t.string :uid
      t.string :name
      t.string :logo
      t.string :email
      t.string :primary_phone_number
      t.string :secondary_phone_number
      t.string :fax

      t.timestamps null: false
    end
    add_index :limo_companies, :email, unique: true
    add_index :limo_companies, :uid, unique: true
  end
end