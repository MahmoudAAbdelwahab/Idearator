class NotificationsTable < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :subtype, :null => false
      t.timestamps
    end
  end
end
