# This migration adds a column id to the tables user_notifications_users and idea_notifications_users to change the relation
# from has_and_belongs_to_many to has_many_through.
class ChangeNotificationRelations < ActiveRecord::Migration
  def up
    add_column :user_notifications_users, :id, :primary_key
    add_column :idea_notifications_users, :id, :primary_key
  end

  def down
    remove_column :user_notifications_users, :id
    remove_column :idea_notifications_users, :id
  end
end