class IdeaNotificationsUsers < ActiveRecord::Migration
  def change
    create_table :idea_notifications_users, :id => false do |t|
    	t.references :user
    	t.references :idea_notification
    end
  end
end
