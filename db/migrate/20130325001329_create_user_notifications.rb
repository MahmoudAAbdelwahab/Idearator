class CreateUserNotifications < ActiveRecord::Migration
  def change
    create_table :user_notifications, :id => false do |t|
    	t.references :user
    	t.references :notification
      t.timestamps
    end
  end
end
