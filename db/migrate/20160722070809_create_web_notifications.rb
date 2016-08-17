class CreateWebNotifications < ActiveRecord::Migration
  def change
    create_table :web_notifications do |t|
      t.text :message
      t.references :notifiable, polymorphic: true, index: true
      t.references :publishable, polymorphic: true, index: true
      t.boolean :read_status, default: false
      t.string :response_status
      t.string :kind

      t.timestamps null: false
    end
  end
end
