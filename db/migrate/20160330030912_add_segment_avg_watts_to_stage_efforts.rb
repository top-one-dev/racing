class AddSegmentAvgWattsToStageEfforts < ActiveRecord::Migration
  def change
    add_column :stage_efforts, :segment_avg_watts, :float
  end
end
