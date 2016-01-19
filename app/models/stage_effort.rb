class StageEffort < ActiveRecord::Base
  belongs_to :stage
  belongs_to :cyclist
  
  default_scope {order('id')}
  #validates :strava_athlete_url, format: {with: /\A(https|http):\/\/www.strava.com\/athletes\/\d+\z/ , message: "It's incorrect althlete url"}

  include StravaClient

  before_save :get_stage_effort_info

  private 
    def get_stage_effort_info      
      match_result = /\d+\z/.match(self.strava_activity_url) 
      activity_id = match_result[0] if match_result   
      print "======#{activity_id}========="        
      if activity_id
        begin          
        	auth_param = 'Bearer ' + self.cyclist.access_token
          result = RestClient.get "https://www.strava.com/api/v3/activities/#{activity_id}?include_all_efforts=true", :Authorization => auth_param
          result_json = JSON.parse(result)
        rescue
        	self.elapsed_time = nil        
        else              	
          self.elapsed_time = 0
          unless result_json['segment_efforts'].nil?                    
            self.stage.segments.each do |segment|                                        
              result_json['segment_efforts'].each do |segment_effort|                              
                print "==#{segment_effort['segment']['id']}--#{segment.strava_segment_id}=="
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
end