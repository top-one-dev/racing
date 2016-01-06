class StageEffort < ActiveRecord::Base
  belongs_to :stage
  belongs_to :cyclist

  #validates :strava_athlete_url, format: {with: /\A(https|http):\/\/www.strava.com\/athletes\/\d+\z/ , message: "It's incorrect althlete url"}

  include StravaClient

  before_save :get_stage_effort_info

  private 
    def get_stage_effort_info
      activity_id = /\d+\z/.match(self.strava_activity_url)[0]      
      begin
      	result = strava_client.retrieve_an_activity(activity_id)
      rescue
      	self.elapsed_time = nil
      else
      	self.elapsed_time = result['elapsed_time']      	
      end
    end
end
