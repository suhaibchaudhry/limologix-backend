class CreateDispatches < ActiveRecord::Migration
  def change
    create_table :dispatches do |t|
      t.references :driver, index: true
      t.references :trip, index: true
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps null: false
    end
  end
end
