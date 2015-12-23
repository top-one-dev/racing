class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.references :race, index: true, foreign_key: true
      t.string :name
      t.string :description
      t.date :active_date
      t.date :close_date

      t.timestamps null: false
    end
  end
end
