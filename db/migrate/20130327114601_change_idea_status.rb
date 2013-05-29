class ChangeIdeaStatus < ActiveRecord::Migration
  	#Remove the status column and add an approved boolean column
  def up
  	remove_column :ideas, :status
  	add_column :ideas, :approved, :boolean, :default => false
  end

  def down
  end
end
