class UserNotificationsUsers < ActiveRecord::Migration
  def change
    create_table :user_notifications_users, :id => false do |t|
    	t.references :user
    	t.references :user_notification
    end
  end
end
