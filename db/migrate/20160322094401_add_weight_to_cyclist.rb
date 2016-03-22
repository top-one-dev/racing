class AddWeightToCyclist < ActiveRecord::Migration
  def change
    add_column :cyclists, :weight, :float
  end
end
