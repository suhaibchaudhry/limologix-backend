class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :color
      t.string :make
      t.string :model
      t.string :hll
      t.string :license_plate
      t.string :features
      t.references :driver, index: true
      t.references :vehicle_type, index: true

      t.timestamps null: false
    end
  end
end
