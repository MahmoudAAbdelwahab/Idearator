class CreateCommitteeIdeas < ActiveRecord::Migration
  def change
    create_table :committee_ideas, :id => false do |t|
      t.references :committee
      t.references :idea
      t.timestamps
    end
  end
end
