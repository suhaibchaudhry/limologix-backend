class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :driver, index: true
      t.integer :amount
      t.string :transaction_number
      t.boolean :status, default: false

      t.timestamps null: false
    end
  end
end
