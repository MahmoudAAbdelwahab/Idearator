class CreateCompetitionNotification < ActiveRecord::Migration
  def change
    create_table :competition_notifications, :inherits => :notification do |t|
      t.string :type
      t.references :user
      t.references :competition
    end
    add_index :competition_notifications, :competition_id
    add_index :competition_notifications, :user_id
  end
end
