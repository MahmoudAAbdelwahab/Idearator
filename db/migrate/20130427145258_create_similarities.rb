class CreateSimilarities < ActiveRecord::Migration
  def change
    create_table :similarities do |t|
      t.references :idea
      t.float :similarity
      t.references :similar_idea

      t.timestamps
    end

    add_index :similarities, :idea_id
    add_index :similarities, :similar_idea_id
  end
end
