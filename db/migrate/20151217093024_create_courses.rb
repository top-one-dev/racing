class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :description
      t.date :active_date
      t.date :close_date

      t.timestamps null: false
    end
  end
end
