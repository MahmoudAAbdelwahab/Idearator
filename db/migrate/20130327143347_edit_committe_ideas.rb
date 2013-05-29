class EditCommitteIdeas < ActiveRecord::Migration
	#Unnecessary table committee_ideas is removed, foriegn key committee_id is put in column in idea
  def up
  	drop_table :committee_ideas
  end
def change
  change_table :ideas do |t|
  t.references :committee
   end
 end
end
