class AddArchiveStatusToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :archive_status, :boolean, :default => false
  end
end
