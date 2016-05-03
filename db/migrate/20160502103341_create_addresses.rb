class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :addressable, polymorphic: true
      t.string :street
      t.string  :city
      t.integer :zipcode
      t.references :state
      t.references :country

      t.timestamps null: false
    end
  end
end
