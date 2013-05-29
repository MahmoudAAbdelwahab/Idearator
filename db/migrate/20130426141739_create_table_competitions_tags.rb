class CreateTableCompetitionsTags < ActiveRecord::Migration
  def change
    create_table :competitions_tags, :id => false do |t|
      t.references :competition
      t.references :tag
    end
  end
end