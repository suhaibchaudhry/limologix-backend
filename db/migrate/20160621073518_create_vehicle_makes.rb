class CreateVehicleMakes < ActiveRecord::Migration
  def change
    create_table :vehicle_makes do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
