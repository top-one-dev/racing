class CreateSegmentEfforts < ActiveRecord::Migration
  def change
    create_table :segment_efforts do |t|
      t.references :segment, index: true, foreign_key: true
      t.references :stage_effort, index: true, foreign_key: true
      t.integer :segment_effort_id
      t.integer :elapsed_time
      t.string :strava_segment_url

      t.timestamps null: false
    end
  end
end
