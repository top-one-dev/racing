class CreateRosters < ActiveRecord::Migration
  def change
    create_table :rosters do |t|
      t.date :join_date
      t.references :race, index: true, foreign_key: true
      t.references :cyclist, index: true, foreign_key: true
      
      t.timestamps null: false
    end
  end
end
