class CreateActionNotifications < ActiveRecord::Migration
  def change
    create_table :action_notifications do |t|
    	t.column :action, :string
    	t.references :notification
      t.timestamps
    end
  end
end
