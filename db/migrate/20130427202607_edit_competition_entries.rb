class EditCompetitionEntries < ActiveRecord::Migration
  def up
    add_column :competition_entries, :rejected, :boolean, :default => false
  end

  def down
    remove_column :competition_entries, :rejected, :boolean, :default => false
  end
end
