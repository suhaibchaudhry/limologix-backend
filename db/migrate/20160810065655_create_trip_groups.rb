class CreateTripGroups < ActiveRecord::Migration
  def change
    create_table :trip_groups do |t|
      t.references :trip, index: true
      t.references :group, index: true

      t.timestamps null: false
    end
  end
end
