class RemoveJoinDateFromCyclist < ActiveRecord::Migration
  def change
  	remove_column :cyclists, :join_date, :date
  end
end
