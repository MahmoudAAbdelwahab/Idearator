class EditIdeaNotifications < ActiveRecord::Migration
  def up
  	add_column :idea_notifications, :link_name, :string, :default => "/"
  end

  def down
  	remove_column :idea_notifications, :link_name
  end
end
