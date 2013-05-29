class EditIdeasTags < ActiveRecord::Migration
  def up
  	remove_column :ideas_tags, :created_at
  	remove_column :ideas_tags, :updated_at
  end

  def down
  end
end
