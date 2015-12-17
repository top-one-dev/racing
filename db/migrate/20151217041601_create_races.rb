class CreateRaces < ActiveRecord::Migration
  def change
    create_table :races do |t|
      t.string :title
      t.string :describe
      t.date :start
      t.date :end

      t.timestamps null: false
    end
  end
end
