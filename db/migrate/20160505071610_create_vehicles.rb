class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :number
      t.references :limo_company, index: true
      t.references :vehicle_type, index: true

      t.timestamps null: false
    end
  end
end
