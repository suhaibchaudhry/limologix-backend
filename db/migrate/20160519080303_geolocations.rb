class Geolocations < ActiveRecord::Migration
  def change
    create_table :geolocations do |t|
      t.string :place
      t.decimal :latitude, precision: 20, scale: 15
      t.decimal :longitude, precision: 20, scale: 15
      t.string :type
      t.references :locatable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
