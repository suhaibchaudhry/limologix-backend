class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
      t.string :poster

      t.timestamps null: false
    end
  end
end
