class EditCommitteesTags < ActiveRecord::Migration
	#remove the timing coloumns from the table
  def up
  	remove_column :committees_tags, :created_at
  	remove_column :committees_tags, :updated_at 

  end

  def down
  end
end
