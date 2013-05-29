class DropNotificationTables < ActiveRecord::Migration
  def up
   	drop_table :notifications
  	drop_table :action_notifications
   	drop_table :committee_notifications
  	drop_table :user_notifications
  end

  def down
  end
end
