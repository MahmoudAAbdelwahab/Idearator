class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
    	t.column :content, :string
        t.column :num_likes, :integer
        t.references :user 
        t.references :idea
      t.timestamps
    end
  end
end
