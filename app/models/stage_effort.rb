class StageEffort < ActiveRecord::Base
  belongs_to :stage
  belongs_to :cyclist
  
  default_scope {order('stage_id, elapsed_time')}

  #validates :strava_athlete_url, format: {with: /\A(https|http):\/\/www.strava.com\/athletes\/\d+\z/ , message: "It's incorrect althlete url"}

  include StravaClient

  before_save :get_stage_effort_info

  public 
    def get_stage_effort_info      
      match_result = /\d+\z/.match(self.strava_activity_url) 
      activity_id = match_result[0] if match_result   
      #print "#{activity_id}"        
      if activity_id
        begin          
        	auth_param = 'Bearer ' + self.cyclist.access_token
          #auth_param = 'Bearer ' + '8b4cf48c943d70868b1224d23268e19ed8e80c2d'
          result = RestClient.get "https://www.strava.com/api/v3/activities/#{activity_id}?include_all_efforts=true", :Authorization => auth_param          
          result_json = JSON.parse(result)
        rescue
        	#self.elapsed_time = nil        
          #self.segment_avg_watts_per_kg = nil
          #self.segment_avg_watts = nil
          print "Connecting strava.com failed"
        else
          self.elapsed_time = 0
          segment_effort_id = 0
          matched_segment_efforts = []
          self.segment_avg_watts = 0

          unless result_json['segment_efforts'].nil?

            self.stage.segments.each do |segment|
              elapsed_time = 0
              segment_avg_watts = 0
              result_json['segment_efforts'].each do |segment_effort|
                if segment_effort['segment']['id'] == segment.strava_segment_id
                  if elapsed_time == 0 or (elapsed_time > segment_effort['elapsed_time'] and not matched_segment_efforts.include?(segment_effort["id"]))
                    elapsed_time = segment_effort['elapsed_time']
                    segment_avg_watts = segment_effort['average_watts']
                    segment_effort_id = segment_effort["id"]
                  end
                end
              end
              self.elapsed_time += elapsed_time
              self.segment_avg_watts = self.segment_avg_watts.to_f + segment_avg_watts.to_f
              matched_segment_efforts << segment_effort_id
              print "-#{elapsed_time}-"
              print "-#{segment_effort_id}-"
            end
            self.segment_avg_watts = self.segment_avg_watts / self.stage.segments.count if self.stage.segments.count > 0
          end
        end
      end
    end
end