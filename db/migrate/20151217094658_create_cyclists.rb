class CreateCyclists < ActiveRecord::Migration
  def change
    create_table :cyclists do |t|
      t.string :name
      t.integer :strava_id
      t.string :description
      t.string :gender
      t.string :age_range
      t.date :join_date

      t.timestamps null: false
    end
  end
end
