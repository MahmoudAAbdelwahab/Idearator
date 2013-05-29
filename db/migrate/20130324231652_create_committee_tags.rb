class CreateCommitteeTags < ActiveRecord::Migration
  def change
     create_table :committee_tags, :id => false do |t|
    	t.references :committee
    	t.references :tag
      t.timestamps
    end
  end
end
