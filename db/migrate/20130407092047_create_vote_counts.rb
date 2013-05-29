class CreateVoteCounts < ActiveRecord::Migration
  #This table is needed to create the Threshold method."prev_day_votes" variable will store the
  #number of votes the idea got the day before, and "curr_day_votes" will store the votes that
  #the idea will get in the new day. Each time the Threshold method is called, the "curr_day_votes"
  #column values will be set to 0, and the previous values will overwrite the column "prev_day_votes".
  def change
    create_table :vote_counts do |t|
      t.references :idea
      t.column :prev_day_votes, :integer, :default => 0
      t.column :curr_day_votes, :integer, :default => 0
    end
  end
end