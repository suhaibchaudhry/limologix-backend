class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :color
      t.string :hll_number
      t.string :license_plate_number
      t.references :driver, index: true
      t.references :vehicle_type, index: true
      t.references :vehicle_model, index: true
      t.references :vehicle_make, index: true

      t.timestamps null: false
    end
  end
end
