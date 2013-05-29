class EditIntegerColumns < ActiveRecord::Migration
 # Integer columns if not initialized would have a value of nil, 
 # which would not be usable.They have to have a default value.
 def change
  	change_column :comments, :num_likes, :integer, :default => 0
  	change_column :ideas, :num_votes, :integer, :default => 0
 end

end