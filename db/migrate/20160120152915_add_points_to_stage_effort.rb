class AddPointsToStageEffort < ActiveRecord::Migration
  def change
    add_column :stage_efforts, :points, :integer
  end
end
