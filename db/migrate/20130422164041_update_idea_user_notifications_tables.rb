class UpdateIdeaUserNotificationsTables < ActiveRecord::Migration
  def change
    drop_table :idea_notifications
    drop_table :user_notifications
    create_table :idea_notifications, :inherits => :notification do |t|
      t.string :type
      t.references :idea
      t.references :user
    end
    add_index :idea_notifications, :idea_id
    add_index :idea_notifications, :user_id

    create_table :user_notifications, :inherits => :notification do |t|
      t.string :type
      t.references :user
    end
    add_index :user_notifications, :user_id
  end
end
