class CreateCommitteeNotifications < ActiveRecord::Migration
  def change
    create_table :committee_notifications do |t|
    	t.references :notification
      t.timestamps
    end
  end
end
