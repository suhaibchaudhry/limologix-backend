class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :addressable, polymorphic: true
      t.string :street
      t.string  :city
      t.integer :zipcode
      t.string :state_code
      t.string :country_code

      t.timestamps null: false
    end
  end
end
