class DeleteNotificationTable < ActiveRecord::Migration
  def change
  create_table :delete_notifications, :inherits => :notification do |t|
      t.string :idea_title
      t.references :idea
      t.references :user
    end
    add_index :delete_notifications, :idea_id
    add_index :delete_notifications, :user_id
  end
end
