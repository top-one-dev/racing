class AddStageNoToStage < ActiveRecord::Migration
  def change
    add_column :stages, :stage_no, :integer
  end
end
