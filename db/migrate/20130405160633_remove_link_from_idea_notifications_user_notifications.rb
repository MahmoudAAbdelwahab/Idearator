class RemoveLinkFromIdeaNotificationsUserNotifications < ActiveRecord::Migration
  #This migration file removes the columns link and link_name from table idea_notifications and user_notifications 
  #as the link part is going to be handled in the view so it is not supposed to be in the database.
  def up
  	remove_column :user_notifications, :link_name
  	remove_column :user_notifications, :link
  	remove_column :idea_notifications, :link_name
  	remove_column :idea_notifications, :link
  end

  def down
  	add_column :user_notifications, :link_name
  	add_column :user_notifications, :link
  	add_column :idea_notifications, :link_name
  	add_column :idea_notifications, :link
  end
end
