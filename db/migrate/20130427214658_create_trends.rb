class CreateTrends < ActiveRecord::Migration
  def change
    create_table :trends do |t|
      t.references :idea
      t.integer :trending , :default => 0
      t.integer :rounds , :default => 0
    end
  end
end
