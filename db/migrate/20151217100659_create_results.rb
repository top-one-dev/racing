class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
    	t.time :time
    	t.references :race, index: true, foreign_key: true
    	t.references :course, index: true, foreign_key: true
    	t.references :segment, index: true, foreign_key: true
    	t.references :cyclist, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end