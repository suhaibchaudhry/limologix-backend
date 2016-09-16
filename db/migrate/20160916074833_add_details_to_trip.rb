class AddDetailsToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :first_name, :string
    add_column :trips, :last_name, :string

    remove_column :trips, :customer_id, :integer
  end
end
