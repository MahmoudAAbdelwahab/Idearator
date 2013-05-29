class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
    	t.column :title, :string, :limit => 100, :null => false
    	t.column :description, :string, :null => false
        t.column :problem_solved, :string, :null => false
        t.column :num_votes, :integer
        t.column :status, :string, :default => "waiting"
        t.references :user 
      t.timestamps
    end
  end
end
