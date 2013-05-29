class CreateThresholds < ActiveRecord::Migration
  def change
    create_table :thresholds do |t|
    	t.column :threshold, :integer
      t.timestamps
    end
  end
end
