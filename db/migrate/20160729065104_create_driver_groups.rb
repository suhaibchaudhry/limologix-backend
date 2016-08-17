class CreateDriverGroups < ActiveRecord::Migration
  def change
    create_table :driver_groups do |t|
      t.references :driver, index: true
      t.references :group, index: true

      t.timestamps null: false
    end
  end
end
