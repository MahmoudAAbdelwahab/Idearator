class DropCommitteeIdeas < ActiveRecord::Migration
	#Drop redundant table.
  def up
  	drop_table :committee_ideas
  end

  def down
  end
end
