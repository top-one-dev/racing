class Segment < ActiveRecord::Base
  default_scope {order('id')}
  belongs_to :stage
  
  include StravaClient

  validates :strava_segment_url, format: {with: /\A(https|http):\/\/www.strava.com\/segments\/\d+\z/ , message: "It's incorrect segment url"}
  before_save :get_segment_info

  private 
    def get_segment_info
    	self.strava_segment_id = /\d+\z/.match(self.strava_segment_url)[0]
    	begin	      
        
	      result = default_strava_client.retrieve_a_segment(self.strava_segment_id)            	      			  
			rescue 
				self.description = "Athlete id does't exist or there is an error."
				self.length = nil
			else
				self.length = (result['distance'].to_f) / 1609.34 #(in mile)      		     
			  self.description = result['name']		      
			end 
    end
end
