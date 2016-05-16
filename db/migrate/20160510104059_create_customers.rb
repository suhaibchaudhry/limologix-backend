class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :mobile_number
      t.string :organisation
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
