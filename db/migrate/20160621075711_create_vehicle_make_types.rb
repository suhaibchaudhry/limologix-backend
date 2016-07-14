class CreateVehicleMakeTypes < ActiveRecord::Migration
  def change
    create_table :vehicle_make_types do |t|
      t.references :vehicle_type, index: true
      t.references :vehicle_make, index: true

      t.timestamps null: false
    end
  end
end
