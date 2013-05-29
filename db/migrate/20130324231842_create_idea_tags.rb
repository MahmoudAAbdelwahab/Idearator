class CreateIdeaTags < ActiveRecord::Migration
  def change
    create_table :idea_tags, :id => false do |t|
    	t.references :idea
    	t.references :tag
      t.timestamps
    end
  end
end
