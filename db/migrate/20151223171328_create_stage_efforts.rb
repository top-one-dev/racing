class CreateStageEfforts < ActiveRecord::Migration
  def change
    create_table :stage_efforts do |t|
      t.references :stage, index: true, foreign_key: true
      t.references :cyclist, index: true, foreign_key: true
      t.string :strava_activity_url

      t.timestamps null: false
    end
  end
end
