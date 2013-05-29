class CreateVotes < ActiveRecord::Migration
  def change
     create_table :votes, :id => false do |t|
    	t.references :idea
    	t.references :user
      t.timestamps
    end
  end
end
