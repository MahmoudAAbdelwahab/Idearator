class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.string :title
      t.string :description
      t.references :investor

      t.timestamps
    end
    add_index :competitions, :investor_id
  end
end
