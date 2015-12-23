class RemoveJoinDateFromRoster < ActiveRecord::Migration
  def change
  	remove_column :rosters, :join_date, :date
  end
end
