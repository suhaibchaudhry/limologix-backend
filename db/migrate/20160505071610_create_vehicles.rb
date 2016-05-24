class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :color
      t.string :hll_number
      t.string :license_plate_number
      t.string :year_of_purchase
      t.references :owner, polymorphic: true, index: true
      t.references :vehicle_type, index: true

      t.timestamps null: false
    end
  end
end
