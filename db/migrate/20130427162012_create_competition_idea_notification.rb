class CreateCompetitionIdeaNotification < ActiveRecord::Migration
  def change
    create_table :competition_idea_notifications, :inherits => :notification do |t|
      t.string :type
      t.references :idea
      t.references :user
      t.references :competition
    end
    add_index :competition_idea_notifications, :idea_id
    add_index :competition_idea_notifications, :competition_id
    add_index :competition_idea_notifications, :user_id
  end
end
