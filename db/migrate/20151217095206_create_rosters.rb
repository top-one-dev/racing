class CreateRosters < ActiveRecord::Migration
  def change
    create_table :rosters do |t|
      t.date :join_date

      t.timestamps null: false
    end
  end
end
