class RenameTableNames < ActiveRecord::Migration
	#rename table names for the relationship to work
  def up
  	rename_table :committee_tags, :committees_tags
  	rename_table :idea_tags, :ideas_tags
  end

  def down
  end
end
