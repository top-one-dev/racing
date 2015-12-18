class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
    	t.time :time

      t.timestamps null: false
    end
  end
end