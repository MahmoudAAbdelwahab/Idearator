class EditUserNotifications < ActiveRecord::Migration
  def up
  	add_column :user_notifications, :link_name, :string, :default => "/"
  end

  def down
    remove_column :user_notifications, :link_name
  end
end
