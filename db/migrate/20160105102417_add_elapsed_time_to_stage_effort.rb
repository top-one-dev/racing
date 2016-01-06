class AddElapsedTimeToStageEffort < ActiveRecord::Migration
  def change
    add_column :stage_efforts, :elapsed_time, :integer #in second
  end
end