class UserNotificationTable < ActiveRecord::Migration
  def change
    create_table :notifications_users do |t|
      t.references :user
      t.references :notification
      t.boolean :read, :default => false
    end
  end
end
