class ChangeNotificationSettingsColumns < ActiveRecord::Migration
# There are two types of notifications with acual settings, either notifications on own idea,
#or on idea participated in by either a vote or a comment. This wasn't clearly stated with these attributes.

  def up
    remove_column :users, :recieve_comment_notification
    remove_column :users, :recieve_vote_notification
    add_column :users, :own_idea_notifications, :boolean, :default => true
    add_column :users, :participated_idea_notifications, :boolean, :default => true
  end

  def down
    add_column :users, :recieve_comment_notification
    add_column :users, :recieve_vote_notification
    remove_column :users, :own_idea_notifications
    remove_column :users, :participated_idea_notifications
  end
end
