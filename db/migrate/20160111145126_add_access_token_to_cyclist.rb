class AddAccessTokenToCyclist < ActiveRecord::Migration
  def change
    add_column :cyclists, :access_token, :string
  end
end
