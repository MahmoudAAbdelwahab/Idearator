class EditIdeaNotificationsUsers < ActiveRecord::Migration
  def up
  	add_column :idea_notifications_users, :read, :boolean, :default => false
  end

  def down
  	remove_column :idea_notifications_users, :read
  end
end
