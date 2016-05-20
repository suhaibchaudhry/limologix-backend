class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.datetime :pick_up_at
      t.integer :passengers_count
      t.references :user, index: true
      t.references :customer, index: true
      t.string :status, default: 'pending'

      t.timestamps null: false
    end
  end
end
