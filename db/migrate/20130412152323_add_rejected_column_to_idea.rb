class AddRejectedColumnToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :rejected, :boolean, :default => false
    change_column :ideas, :approved, :boolean, :default => false
  end
end
