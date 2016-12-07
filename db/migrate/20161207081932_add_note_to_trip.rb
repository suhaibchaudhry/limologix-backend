class AddNoteToTrip < ActiveRecord::Migration
  def change
  	add_column :trips, :note, :text
  end
end
