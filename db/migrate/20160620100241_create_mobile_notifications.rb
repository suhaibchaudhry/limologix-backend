class CreateMobileNotifications < ActiveRecord::Migration
  def change
    create_table :mobile_notifications do |t|
      t.string :title
      t.text :body
      t.text :data
      t.references :notifiable, polymorphic: true, index: true
      t.references :driver, index: true
      t.string :status
      t.string :response
      t.string :kind

      t.timestamps null: false
    end
  end
end
