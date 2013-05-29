class AddColumnsToCompetition < ActiveRecord::Migration
  def change
    change_table :competitions do |t|
      t.references :idea
      t.date :start_date
      t.date :end_date
    end
  end
end
