class AddWinnerToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :winner, :int
  end
end
