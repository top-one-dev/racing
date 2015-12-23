class CreateSegments < ActiveRecord::Migration
  def change
    create_table :segments do |t|
      t.string :strava_segment_url
      t.integer :strava_segment_id
      t.string :description
      t.float :length
      t.references :stage, index: true, foreign_key: true
      
      t.timestamps null: false
    end
  end
end
