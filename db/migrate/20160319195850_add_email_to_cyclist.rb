class AddEmailToCyclist < ActiveRecord::Migration
  def change
    add_column :cyclists, :email, :string
  end
end
