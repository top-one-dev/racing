class RemoveDescFromCyclist < ActiveRecord::Migration
  def change
  	remove_column :cyclists, :description, :string
  end
end
