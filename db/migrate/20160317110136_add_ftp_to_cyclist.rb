class AddFtpToCyclist < ActiveRecord::Migration
  def change
    add_column :cyclists, :ftp, :integer
  end
end
