class AddSecondaryAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :secondary_address, :string
  end
end
