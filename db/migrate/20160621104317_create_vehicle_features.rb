class CreateVehicleFeatures < ActiveRecord::Migration
  def change
    create_table :vehicle_features do |t|
      t.string :name
      t.references :vehicle, index: true

      t.timestamps null: false
    end
  end
end
