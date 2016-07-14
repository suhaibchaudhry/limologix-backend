class CreateTripNotifications < ActiveRecord::Migration
  def change
    create_table :trip_notifications do |t|
      t.string :title
      t.text :body
      t.references :trip, index: true
      t.references :driver, index: true
      t.string :status
      t.string :response
      t.string :kind

      t.timestamps null: false
    end
  end
end
