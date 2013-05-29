class EditIdeaApprovedColumn < ActiveRecord::Migration
  def change
    change_column :ideas, :approved, :integer, :default => 0
  end
end