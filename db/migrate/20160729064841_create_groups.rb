class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.references :company, index: true
      t.string :name
      t.text :description
      t.string :status

      t.timestamps null: false
    end
  end
end
