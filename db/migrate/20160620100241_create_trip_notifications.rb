class CreateTripNotifications < ActiveRecord::Migration
  def change
    create_table :trip_notifications do |t|
      t.text :message
      t.references :trip, index: true
      t.references :driver, index: true
      t.string :kind

      t.timestamps null: false
    end
  end
end
