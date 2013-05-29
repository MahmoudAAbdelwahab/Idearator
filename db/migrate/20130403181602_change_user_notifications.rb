class ChangeUserNotifications < ActiveRecord::Migration
  def change
    create_table :user_notifications do |t|
      t.string :type
      t.string :link
      t.references :user

      t.timestamps
    end
    add_index :user_notifications, :user_id
  end
end
