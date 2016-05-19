class Geolocations < ActiveRecord::Migration
  def change
    create_table :geolocations do |t|
      t.string :name
      t.string :latitude
      t.string :longitude
      t.string :type
      t.references :locatable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
