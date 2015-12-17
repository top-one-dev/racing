class CreateDirectors < ActiveRecord::Migration
  def change
    create_table :directors do |t|

      t.timestamps null: false
    end
  end
end
