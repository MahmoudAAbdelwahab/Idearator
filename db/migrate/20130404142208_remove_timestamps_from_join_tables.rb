class RemoveTimestampsFromJoinTables < ActiveRecord::Migration
	#remove the timestamps from the joining tables to make the
	#HABTM relationship work.
  def change
    remove_column :likes, :created_at
  	remove_column :likes, :updated_at

  	remove_column :votes, :created_at
  	remove_column :votes, :updated_at 
   end
end
