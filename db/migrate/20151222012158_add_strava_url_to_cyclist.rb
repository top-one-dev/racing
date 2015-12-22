class AddStravaUrlToCyclist < ActiveRecord::Migration
  def change
    add_column :cyclists, :strava_url, :string
  end
end
