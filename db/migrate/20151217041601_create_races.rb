class CreateRaces < ActiveRecord::Migration
  def change
    create_table :races do |t|
      t.string :name
      t.string :description
      t.date :start_date
      t.date :end_date
      t.string :hashtag
      
      t.timestamps null: false
    end
  end
end
