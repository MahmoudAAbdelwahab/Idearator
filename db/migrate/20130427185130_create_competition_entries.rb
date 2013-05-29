class CreateCompetitionEntries < ActiveRecord::Migration
  def change
    create_table :competition_entries do |t|
      t.references :idea
      t.references :competition
      t.boolean :approved, :default => false
      t.timestamps
    end
    add_index :competition_entries, :idea_id
    add_index :competition_entries, :competition_id
  end
end
