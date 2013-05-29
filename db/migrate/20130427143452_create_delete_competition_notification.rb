class CreateDeleteCompetitionNotification < ActiveRecord::Migration
  def change
  create_table :delete_competition_notifications, :inherits => :notification do |t|
      t.string :competition_title
      t.references :competition
      t.references :user
    end
    add_index :delete_competition_notifications, :competition_id
    add_index :delete_competition_notifications, :user_id
  end
end
