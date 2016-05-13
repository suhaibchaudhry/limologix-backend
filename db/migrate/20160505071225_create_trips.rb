class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :start_destination
      t.string :end_destination
      t.datetime :pick_up_at
      t.references :user, index: true
      t.string :status, default: 'pending'

      t.timestamps null: false
    end
  end
end
