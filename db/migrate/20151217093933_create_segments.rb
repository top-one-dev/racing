class CreateSegments < ActiveRecord::Migration
  def change
    create_table :segments do |t|
      t.string :strava_url
      t.string :description
      t.float :length

      t.timestamps null: false
    end
  end
end
