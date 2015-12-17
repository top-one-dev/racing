class CreateCyclists < ActiveRecord::Migration
  def change
    create_table :cyclists do |t|
      t.string :name
      t.string :description
      t.string :gender
      t.date :join_date

      t.timestamps null: false
    end
  end
end
