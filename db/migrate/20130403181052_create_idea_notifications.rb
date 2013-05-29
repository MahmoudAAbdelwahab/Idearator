class CreateIdeaNotifications < ActiveRecord::Migration
  def change
    create_table :idea_notifications do |t|
      t.string :type
      t.string :link
      t.references :idea
      t.references :user

      t.timestamps
    end
    add_index :idea_notifications, :idea_id
    add_index :idea_notifications, :user_id
  end
end
