class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :color
      t.string :make
      t.string :model
      t.string :hll_number
      t.string :license_plate_number
      t.string :features
      t.references :driver, index: true
      t.references :vehicle_type, index: true

      t.timestamps null: false
    end
  end
end
