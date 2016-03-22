class AddPremiumToCyclist < ActiveRecord::Migration
  def change
    add_column :cyclists, :premium, :boolean
  end
end
