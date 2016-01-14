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
      	result = my_strava_client(self.cyclist.access_token).retrieve_an_activity(activity_id)        
      rescue
      	self.elapsed_time = nil        
      else              	
        self.elapsed_time = 0
        unless result['segment_efforts'].nil?          
          self.stage.segments.each do |segment|                                
            result['segment_efforts'].each do |segment_effort|              
              #print "==#{segment_effort['segment']['id']}--#{segment.strava_segment_id}=="
              if segment_effort['segment']['id'] == segment.strava_segment_id
                self.elapsed_time += segment_effort['elapsed_time']
                break
              end
            end
          end
        end        
      end
    end
end
